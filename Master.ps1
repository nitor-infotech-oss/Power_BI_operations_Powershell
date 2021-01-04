$groupID = "8eada71d-766c-4cab-874e-0d7ec507ac2b" # the ID of the group that hosts the dataset. Use "me" if this is your My Workspace 0084cabe-a616-4e19-b516-6896a5429504
#$datasetID = "20d498d0-9029-4f09-aab9-7f4942625f2b" # the ID of the dataset that hosts the dataset

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
$body = '{
"updateDetails": [
    {
      "name": "Tracker_ID",
      "newValue": "8084225"
    },
	
	 {
      "name": "Retailer_CD",
      "newValue": "ABN"
    }
  ]
}'

$body_temp = ConvertFrom-Json -InputObject $body

$body = $body_temp | ConvertTo-Json


$uri = "https://api.powerbi.com/v1.0/myorg/datasets/bd94fcf1-7f77-4a6b-a243-90b102f7a61f/Default.UpdateParameters"

$payload = Invoke-RestMethod -Uri $uri -Headers $authHeader -Method Post -Body $body -Verbose

echo "Successfully executed!!!"



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

$groupID = "8eada71d-766c-4cab-874e-0d7ec507ac2b" # the ID of the group that hosts the dataset. Use "me" if this is your My Workspace 0084cabe-a616-4e19-b516-6896a5429504
$datasetID = "bd94fcf1-7f77-4a6b-a243-90b102f7a61f" # the ID of the dataset that hosts the dataset

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


$clientId = "c1c04507-9857-44cc-8c25-ee02824671f7" 
$userName = "dynamics_service@nitorinfotech.com"
$password = "Nitor@1234"  #lqpssktddmqqzwfy 

# End Parameters =======================================

# TODO: move helper functions into a separate file
# Calls the Active Directory Authentication Library (ADAL) to authenticate against AAD
function GetAuthToken
{
    if(-not (Get-Module AzureRm.Profile)) {
      Import-Module AzureRm.Profile
    }

    $redirectUri = "urn:ietf:wg:oauth:2.0:oob"

    $resourceAppIdURI = "https://analysis.windows.net/powerbi/api"

    $authority = "https://login.microsoftonline.com/common/oauth2/authorize";

    $authContext = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext" -ArgumentList $authority
	
	$creds = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.UserCredential" -ArgumentList $userName,$password
	
	 $authResult = $authContext.AcquireToken($resourceAppIdURI, $clientId, $creds)

    #$authResult = $authContext.AcquireToken($resourceAppIdURI, $clientId, $redirectUri, "Auto")

    return $authResult
}

function get_groups_path($group_id) {
    if ($group_id -eq "me") {
        return "myorg"
    } else {
        return "myorg/groups/$group_ID"
    }
}

# PART 1: Authentication
# ==================================================================
$token = GetAuthToken

Add-Type -AssemblyName System.Net.Http
$temp_path_root = "$PSScriptRoot\pbi-copy-workspace-temp-storage"

# Building Rest API header with authorization token
$auth_header = @{
   'Content-Type'='application/json'
   'Authorization'=$token.CreateAuthorizationHeader()
}

# Prompt for user input
# ==================================================================
# Get the list of groups that the user is a member of
$uri = "https://api.powerbi.com/v1.0/myorg/groups/"
$all_groups = (Invoke-RestMethod -Uri $uri -Headers $auth_header -Method GET).value

# Ask for the source workspace name
$source_group_ID = "8eada71d-766c-4cab-874e-0d7ec507ac2b"

while (!$source_group_ID) {
    $source_group_name = Read-Host -Prompt "Enter the name of the workspace you'd like to copy from"

    if($source_group_name -eq "My Workspace") {
        $source_group_ID = "me"
        break
    }

    Foreach ($group in $all_groups) {
        if ($group.name -eq $source_group_name) {
            if ($group.isReadOnly -eq "True") {
                "Invalid choice: you must have edit access to the group"
                break
            } else {
                $source_group_ID = $group.id
                break
            }
        }
    }

    if(!$source_group_id) {
        "Please try again, making sure to type the exact name of the group"  
    } 
}

# Ask for the target workspace name
$target_group_ID = "5cbe523c-a25c-4b2a-af87-2b87d8273218" 
while (!$target_group_id) {
    try {
        $target_group_name = Read-Host -Prompt "Enter the name of the new workspace to be created"
        $uri = " https://api.powerbi.com/v1.0/myorg/groups"
        $body = "{`"name`":`"$target_group_name`"}"
        $response = Invoke-RestMethod -Uri $uri -Headers $auth_header -Method POST -Body $body
        $target_group_id = $response.id
    } catch { 
        "Could not create a group with that name. Please try again and make sure the name is not already taken"
        "More details: "
        Write-Host "StatusCode:" $_.Exception.Response.StatusCode.value__ 
        Write-Host "StatusDescription:" $_.Exception.Response.StatusDescription
        continue
    }
}

# PART 3: Copying reports and datasets using Export/Import PBIX APIs
# ==================================================================
$report_ID_mapping = @{}      # mapping of old report ID to new report ID
$dataset_ID_mapping = @{}     # mapping of old model ID to new model ID
$failure_log = @()  
$import_jobs = @()
$source_group_path = get_groups_path($source_group_ID)
$target_group_path = get_groups_path($target_group_ID)

$uri = "https://api.powerbi.com/v1.0/$source_group_path/reports/"
$reports_json = Invoke-RestMethod -Uri $uri -Headers $auth_header -Method GET
$reports = $reports_json.value

# For My Workspace, filter out reports that I don't own - e.g. those shared with me
if ($source_group_ID -eq "me") {
    $reports_temp = @()
    Foreach($report in $reports) {
        if ($report.isOwnedByMe -eq "True") {
            $reports_temp += $report
        }
    }
    $reports = $reports_temp
}

# == Export/import the reports that are built on PBIXes (this step creates the datasets)
# for each report, try exporting and importing the PBIX
New-Item -Path $temp_path_root -ItemType Directory 
"=== Exporting PBIX files to copy datasets..."
Foreach($report in $reports) {
   
    $report_id = $report.id
    $dataset_id = $report.datasetId
    $report_name = Read-Host -Prompt "Enter the name of the new Report to be created"
    $temp_path = "$temp_path_root\$report_name.pbix"

    # only export if this dataset hasn't already been seen
    if ($dataset_ID_mapping[$dataset_id]) {
        continue
    }

    "== Exporting $report_name with id: $report_id to $temp_path"
    $uri = "https://api.powerbi.com/v1.0/$source_group_path/reports/$report_id/Export"
    try {
        Invoke-RestMethod -Uri $uri -Headers $auth_header -Method GET -OutFile "$temp_path"
    } catch {
        Write-Host "= This report and dataset cannot be copied, skipping. This is expected for most workspaces."
        continue
    }
     
    try {
        "== Importing $report_name to target workspace"
        $uri = "https://api.powerbi.com/v1.0/$target_group_path/imports/?datasetDisplayName=$report_name.pbix&nameConflict=Abort"

        # Here we switch to HttpClient class to help POST the form data for importing PBIX
        $httpClient = New-Object System.Net.Http.Httpclient $httpClientHandler
        $httpClient.DefaultRequestHeaders.Authorization = New-Object System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", $token.AccessToken);
        $packageFileStream = New-Object System.IO.FileStream @($temp_path, [System.IO.FileMode]::Open)
        
	    $contentDispositionHeaderValue = New-Object System.Net.Http.Headers.ContentDispositionHeaderValue "form-data"
	    $contentDispositionHeaderValue.Name = "file0"
	    $contentDispositionHeaderValue.FileName = $file_name
 
        $streamContent = New-Object System.Net.Http.StreamContent $packageFileStream
        $streamContent.Headers.ContentDisposition = $contentDispositionHeaderValue
        
        $content = New-Object System.Net.Http.MultipartFormDataContent
        $content.Add($streamContent)

	    $response = $httpClient.PostAsync($Uri, $content).Result
 
	    if (!$response.IsSuccessStatusCode) {
		    $responseBody = $response.Content.ReadAsStringAsync().Result
            "= This report cannot be imported to target workspace. Skipping..."
			$errorMessage = "Status code {0}. Reason {1}. Server reported the following message: {2}." -f $response.StatusCode, $response.ReasonPhrase, $responseBody
			throw [System.Net.Http.HttpRequestException] $errorMessage
		} 
        
        # save the import IDs
        $import_job_id = (ConvertFrom-JSON($response.Content.ReadAsStringAsync().Result)).id

        # wait for import to complete
        $upload_in_progress = $true
        while($upload_in_progress) {
            $uri = "https://api.powerbi.com/v1.0/$target_group_path/imports/$import_job_id"
            $response = Invoke-RestMethod -Uri $uri -Headers $auth_header -Method GET
            
            if ($response.importState -eq "Succeeded") {
                "Publish succeeded!"
                # update the report and dataset mappings
                $report_id_mapping[$report_id] = $response.reports[0].id
                $dataset_id_mapping[$dataset_id] = $response.datasets[0].id
                break
            }

            if ($response.importState -ne "Publishing") {
                "Error: publishing failed, skipping this. More details: "
                $response
                break
            }
            
            Write-Host -NoNewLine "."
            Start-Sleep -s 5
        }
            
        
    } catch [Exception] {
        Write-Host $_.Exception
	    Write-Host "== Error: failed to import PBIX"
        Write-Host "= HTTP Status Code:" $_.Exception.Response.StatusCode.value__ 
        Write-Host "= HTTP Status Description:" $_.Exception.Response.StatusDescription
        continue
    }
}

# PART 4: Clone the remainder of the reports
# ==================================================================
"=== Cloning reports" 
Foreach($report in $reports) {
    $report_name = $report.name
    $report_id = $report.id

    # Clone report if the underlying dataset already exists in the target workspace, but we haven't moved the report itself yet
    $target_dataset_Id = $dataset_id_mapping[$report.datasetId]
    if ($target_dataset_Id -and !$report_ID_mapping[$report.id]) {
        "== Cloning report $report_name"
        $uri = " https://api.powerbi.com/v1.0/$source_group_path/reports/$report_id/Clone"
        $body = "{`"name`":`"$report_name`",`"targetWorkspaceId`": `"$target_group_id`", `"targetModelId`": `"$target_dataset_Id`"}"
        $response = Invoke-RestMethod -Uri $uri -Headers $auth_header -Method POST -Body $body
        $report_ID_mapping[$report_id] = $response.id
    } else {
        $failure_log += $report
    }
}

# PART 5: Copy dashboards
# ==================================================================
"=== Cloning dashboards" 
# get all dashboards in a workspace
$uri = "https://api.powerbi.com/v1.0/$source_group_path/dashboards/"
$dashboards = (Invoke-RestMethod -Uri $uri -Headers $auth_header -Method GET).value

# For My Workspace, filter out dashboards that I don't own - e.g. those shared with me
if ($source_group_ID -eq "me") {
    $dashboards_temp = @()
    Foreach($dashboard in $dashboards) {
        if ($dashboard.isReadOnly -ne "True") {
            $dashboards_temp += $dashboard
        }
    }
    $dashboards = $dashboards_temp
}

Foreach ($dashboard in $dashboards) {
    $dashboard_id = $dashboard.id
    $dashboard_name = $dashboard.displayName

    "== Cloning dashboard: $dashboard_name"

    # create new dashboard in the target workspace
    $uri = "https://api.powerbi.com/v1.0/$target_group_path/dashboards"
    $body = "{`"name`":`"$dashboard_name`"}"
    $response = Invoke-RestMethod -Uri $uri -Headers $auth_header -Method POST -Body $body
    $target_dashboard_id = $response.id

    " = Cloning individual tiles..." 
    # copy over tiles:
    $uri = "https://api.powerbi.com/v1.0/$source_group_path/dashboards/$dashboard_id/tiles"
    $response = Invoke-RestMethod -Uri $uri -Headers $auth_header -Method GET 
    $tiles = $response.value
    Foreach ($tile in $tiles) {
        try {
            $tile_id = $tile.id
            $tile_report_Id = $tile.reportId
            $tile_dataset_Id = $tile.datasetId
            if ($tile_report_id) { $tile_target_report_id = $report_id_mapping[$tile_report_id] }
            if ($tile_dataset_id) { $tile_target_dataset_id = $dataset_id_mapping[$tile_dataset_id] }

            # clone the tile only if a) it is not built on a dataset or b) if it is built on a report and/or dataset that we've moved
            if (!$tile_report_id -Or $dataset_id_mapping[$tile_dataset_id]) {
                $uri = " https://api.powerbi.com/v1.0/$source_group_path/dashboards/$dashboard_id/tiles/$tile_id/Clone"
                $body = @{}
                $body["TargetDashboardId"] = $target_dashboard_id
                $body["TargetWorkspaceId"] = $target_group_id
                if ($tile_report_id) { $body["TargetReportId"] = $tile_target_report_id } 
                if ($tile_dataset_id) { $body["TargetModelId"] = $tile_target_dataset_id } 
                $jsonBody = ConvertTo-JSON($body)
                $response = Invoke-RestMethod -Uri $uri -Headers $auth_header -Method POST -Body $jsonBody
                Write-Host -NoNewLine "."
            } else {
                $failure_log += $tile
            } 
           
        } catch [Exception] {
            "Error: skipping tile..."
            Write-Host $_.Exception
        }
    }
    "Done!"
}

"Cleaning up temporary files"
Remove-Item -path $temp_path_root -Recurse
echo "Done!!!"







