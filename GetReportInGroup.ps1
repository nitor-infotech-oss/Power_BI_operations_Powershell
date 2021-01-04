$groupID = "fill me" # the ID of the group that hosts the dataset. Use "me" if this is your My Workspace 0084cabe-a616-4e19-b516-6896a5429504
#$datasetID = "fill me" # the ID of the dataset that hosts the dataset

# AAD Client ID
# To get this, go to the following page and follow the steps to provision an app
# https://dev.powerbi.com/apps
# To get the sample to work, ensure that you have the following fields:
# App Type: Native app
# Redirect URL: urn:ietf:wg:oauth:2.0:oob
#  Level of access: all dataset APIs
$clientId    = "fill me" 
$userName    = "fill me"
$password    = "fill me"

# End Parameters =======================================

# Calls the Active Directory Authentication Library (ADAL) to authenticate against AAD
function GetAuthToken
{
    
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

#$dataSets = Invoke-RestMethod -Uri $uri -Headers $authHeader -Method GET | ConvertTo-Json

#$resultDataset = ConvertFrom-Json -InputObject $dataSets

#echo $resultDataset.value 


$body_temp = ConvertFrom-Json -InputObject $body

$body = $body_temp | ConvertTo-Json


$uri = "https://api.powerbi.com/v1.0/myorg/groups/{groupId}/reports/{reportId}"

$payload = Invoke-RestMethod -Uri $uri -Headers $authHeader -Method GET -Verbose

echo "Successfully executed!!!"