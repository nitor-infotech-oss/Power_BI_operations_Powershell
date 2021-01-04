
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
$SqlConnection.ConnectionString = "Server=srai-cohort-qa.public.affc0573eb96.database.windows.net,3342;Integrated Security = False; User Id=sraiqadataloadprd; PASSWORD=R4KSYTpWjsQn; Initial Catalog=srai-rep-qa"
$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
$SqlCmd.CommandText = "select null where 1<>1
union all
select top 1 sql_query from dbo.PBI_Emp_Tracker where STATUS_ID = 2"
$SqlCmd.Connection = $SqlConnection
$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
$SqlAdapter.SelectCommand = $SqlCmd
$DataSet =  New-Object System.Data.DataSet
$SqlAdapter.Fill($DataSet)
$DataSet.Tables[0]
$SqlConnection.Close()
foreach ($row in $DataSet.Tables[0].Rows)
{ 
  #write-host "$($Row[0])"
}
#echo $Row[0]
$test=$($Row[0])





$groupID = "8eada71d-766c-4cab-874e-0d7ec507ac2b" # the ID of the group that hosts the dataset. Use "me" if this is your My Workspace 0084cabe-a616-4e19-b516-6896a5429504
#$datasetID = "fill me" # the ID of the dataset that hosts the dataset

# AAD Client ID
# To get this, go to the following page and follow the steps to provision an app
# https://dev.powerbi.com/apps
# To get the sample to work, ensure that you have the following fields:
# App Type: Native app
# Redirect URL: urn:ietf:wg:oauth:2.0:oob
#  Level of access: all dataset APIs
$clientId    = "c1c04507-9857-44cc-8c25-ee02824671f7" 
$userName    = "dynamics_service@nitorinfotech.com"
$password    = "Nitor@1234"

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
$postParams = @{
    updateDetails= @(
    @{
        name="Sql_Query"
        newValue = "$test"
    }
   
    )
}

#echo $Env:PSModulePath

$jsonPostBody = $postParams | ConvertTo-JSON


echo $jsonPostBody 



$uri = "https://api.powerbi.com/v1.0/myorg/datasets/dbbd7aed-9e7e-4d70-88bc-4133dbb9fec9/Default.UpdateParameters"

$payload = Invoke-RestMethod -Uri $uri -Headers $authHeader -Method Post -Body $jsonPostBody -Verbose

echo "Successfully executed!!!"


$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
$SqlConnection.ConnectionString = "Server=srai-cohort-qa.public.affc0573eb96.database.windows.net,3342;Integrated Security = False; User Id=sraiqadataloadprd; PASSWORD=R4KSYTpWjsQn; Initial Catalog=srai-rep-qa"
$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
$SqlCmd.CommandText = "update [dbo].PBI_Emp_Tracker 
	set STATUS_ID=40 where SQL_QUERY = (select top 1 SQL_QUERY from dbo.PBI_Emp_Tracker where STATUS_ID = 2 )"
$SqlCmd.Connection = $SqlConnection
$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
$SqlAdapter.SelectCommand = $SqlCmd
$DataSet =  New-Object System.Data.DataSet
$SqlAdapter.Fill($DataSet)
$DataSet.Tables[0]
$SqlConnection.Close()