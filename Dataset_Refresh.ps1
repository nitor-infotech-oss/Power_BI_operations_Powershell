# This sample script calls the Power BI API to progammtically trigger a refresh for the dataset
# It then calls the Power BI API to progammatically to get the refresh history for that dataset
# For full documentation on the REST APIs, see:
# https://msdn.microsoft.com/en-us/library/mt203551.aspx 

# Instructions:
# 1. Install PowerShell (https://msdn.microsoft.com/en-us/powershell/scripting/setup/installing-windows-powershell) and the Azure PowerShell cmdlets (https://aka.ms/webpi-azps)
# 2. Set up a dataset for refresh in the Power BI service - make sure that the dataset can be 
# updated successfully
# 3. Fill in the parameters below
# 4. Run the PowerShell script

# Parameters - fill these in before running the script!
# =====================================================

# An easy way to get group and dataset ID is to go to dataset settings and click on the dataset
# that you'd like to refresh. Once you do, the URL in the address bar will show the group ID and 
# dataset ID, in the format: 
# app.powerbi.com/groups/{groupID}/settings/datasets/{datasetID} 

$groupID = "Fill me" # the ID of the group that hosts the dataset. Use "me" if this is your My Workspace 0084cabe-a616-4e19-b516-6896a5429504
$datasetID = "Fill me" # the ID of the dataset that hosts the dataset

# AAD Client ID
# To get this, go to the following page and follow the steps to provision an app
# https://dev.powerbi.com/apps
# To get the sample to work, ensure that you have the following fields:
# App Type: Native app
# Redirect URL: urn:ietf:wg:oauth:2.0:oob
#  Level of access: all dataset APIs
$clientId    = "Fill me" 
$userName    = "Fill me"
$password    = "Fill me"

# End Parameters =======================================

# Calls the Active Directory Authentication Library (ADAL) to authenticate against AAD
function GetAuthToken
{
    $adal = "${env:ProgramFiles}\WindowsPowerShell\Modules\AzureRM.profile\4.6.0\Microsoft.IdentityModel.Clients.ActiveDirectory.dll"
    
    $adalforms = "${env:ProgramFiles}\WindowsPowerShell\Modules\AzureRM.profile\4.6.0\Microsoft.IdentityModel.Clients.ActiveDirectory.WindowsForms.dll"
 
    #[System.Reflection.Assembly]::LoadFrom($adal) | Out-Null

    #[System.Reflection.Assembly]::LoadFrom($adalforms) | Out-Null

    $redirectUri = "urn:ietf:wg:oauth:2.0:oob"

    $resourceAppIdURI = "https://analysis.windows.net/powerbi/api"

    $authority = "https://login.microsoftonline.com/common/oauth2/authorize";
	
	$creds = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.UserCredential" -ArgumentList $userName,$password

    $authContext = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext" -ArgumentList $authority

    $authResult = $authContext.AcquireToken($resourceAppIdURI, $clientId, $creds)

    return $authResult
}

# Get the auth token from AAD
$token = GetAuthToken

# Building Rest API header with authorization token
$authHeader = @{
   'Content-Type'='application/json'
   'Authorization'=$token.CreateAuthorizationHeader()
}

# properly format groups path
$groupsPath = ""
if ($groupID -eq "me") {
    $groupsPath = "myorg"
} else {
    $groupsPath = "myorg/groups/$groupID"
}

$uri = "https://api.powerbi.com/v1.0/$groupsPath/datasets/"

$dataSets = Invoke-RestMethod -Uri $uri -Headers $authHeader -Method GET | ConvertTo-Json

$resultDataset = ConvertFrom-Json -InputObject $dataSets

#echo $resultDataset.value 

# Refresh the dataset
$uri = "https://api.powerbi.com/v1.0/$groupsPath/datasets/$datasetID/refreshes"
#POST   https://api.powerbi.com/v1.0/myorg/groups/{group_id}/datasets/{dataset_id}/refreshes
$resp = Invoke-RestMethod -Uri $uri -Headers $authHeader -Method POST -Verbose

# Check the refresh history
$uri = "https://api.powerbi.com/v1.0/$groupsPath/datasets/$datasetID/refreshes"
$payload = Invoke-RestMethod -Uri $uri -Headers $authHeader -Method GET -Verbose | ConvertTo-Json |
ConvertFrom-Json |
Select -ExpandProperty value |
Select id, refreshType, startTime, endTime, status
echo $payload