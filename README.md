#  1. Objective

    1. This document will help to understand various possible PowerBI operations and how it can be achieved using PowerShell and Rest API’s.
    2. Also covered pre-requisites, PowerShell dependencies to be included and Sample code for each of the PowerBI operations.
    3. This could be helpful to implement & maintain automated processes for PowerBI.
    4. Developer will be able to use Sample code provided. 

#  2. Prerequisites

#####  1. PowerBI On Prem Gateway
PowerBI on prem gateway will act as bridge between on prem database and PowerBI services. Refer below document attached herewith to set up On Prem gateway.

#### Power BI on-prem gateway.docs-

#####   2. PowerBI App registration to consume API
Go to https://dev.powerbi.com/apps and sign in. Click on Next to Register your application. Provide application name (Anything) and select application type as Native.

![alt text](https://user-images.githubusercontent.com/30488901/103503693-167a7480-4e7b-11eb-8c23-7e45f8c59d48.png "Logo Title Text 1")


Select the APIs and the level of access your application needs. You can change these settings later in the Azure portal.
Once you are done with Application registration, you will get Client Id which is needed.

   # 3. Data Set Operations using PowerShell

#### 3.1 Get Dataset in Group
Returns the specified dataset from the specified workspace. 
GET URL:-https://api.powerbi.com/v1.0/myorg/groups/{groupId}/datasets/{datasetId}

Power Shell Code for Get Dataset in Group




#### 3.2 Delete Dataset in Group 

Deletes the specified dataset from "My Workspace".
Delete URL:-https://api.powerbi.com/v1.0/myorg/datasets/{datasetId}

Power Shell Code for Delete Dataset




#### 3.3 Dataset Refresh  

Triggers a refresh for the specified dataset from "My Workspace".
In Shared capacities this call is limited to eight times per day (including refreshes executed via Scheduled Refresh).

In Premium capacities this call is not limited in number of times per day, but only by the available resources in the capacity, hence if overloaded, the refresh execution may be throttled until the load is reduced. If this throttling exceeds 1 hour, the refresh will fail. 

Post URL- https://api.powerbi.com/v1.0/myorg/datasets/{datasetId}/refreshes

Power Shell Code for Refresh the dataset




#### 3.4 Update Dataset Parameter 

Updates the parameters values for the specified dataset from "My Workspace".
Note: When using this API, it's recommended to use enhanced dataset metadata.
Important: The dataset must be refreshed for new parameters values to be applied. If you're not using enhanced dataset metadata, wait 30 minutes for the update parameters operation to complete before refreshing.

Post URL
https://api.powerbi.com/v1.0/myorg/datasets/{datasetId}/Default.UpdateParameters

Power Shell Code For update dataset parameter





#### 3.5 Get Direct Query Refresh Schedule in Group  

Returns the refresh schedule of a specified DirectQuery or LiveConnection dataset from the specified workspace.

GET URL
https://api.powerbi.com/v1.0/myorg/groups/{groupId}/datasets/{datasetId}/directQueryRefreshSchedule

Power Shell Code for Get Direct Query Refresh Schedule





#### 3.6 Get Parameters  

Returns a list of parameters for the specified dataset from "My Workspace".

GET URL
https://api.powerbi.com/v1.0/myorg/datasets/{datasetId}/parameters

Power Shell Code for Get parameter




#### 3.7 Get Refresh History  

Returns the refresh history of the specified dataset from "My Workspace".

GET URL
https://api.powerbi.com/v1.0/myorg/datasets/{datasetId}/refreshes

Optional Parameter
https://api.powerbi.com/v1.0/myorg/datasets/{datasetId}/refreshes?$top={$top}

Power Shell Code to Get Refresh History



#### 3.8 Update Refresh Schedule in Group  

Updates the refresh schedule for the specified dataset from the specified workspace.

Note: This operation is only supported for the dataset owner.
A request that disables the refresh schedule should contain no other changes.
The days array should not be set to empty array.

Patch URL
https://api.powerbi.com/v1.0/myorg/groups/{groupId}/datasets/{datasetId}/refreshSchedule

Power Shell Code for update Refresh Schedule.



#### 3.9 Bind to Gateway  

Binds the specified dataset from "My Workspace" to the specified gateway with (optional) given set of data source Ids. This only supports the On-Premises Data Gateway.

Post URL
https://api.powerbi.com/v1.0/myorg/datasets/{datasetId}/Default.BindToGateway

Power Shell Code for bind to Gateway




# 4. Group/Worspace Operations using PowerShell

#### 4.1 Create Group  

Creates new workspace.

Post URL
https://api.powerbi.com/v1.0/myorg/groups

Power Shell Code for Create workspace



#### 4.2 Add New User to Workspace   

Grants the specified user permissions to the specified workspace.

Notes: Users that have been recently added to a group may not have their new group immediately available, see Refresh user permissions.

Post URL
https://api.powerbi.com/v1.0/myorg/groups/{groupId}/users

Power Shell Code to Add user to Workspace



#### 4.3 Copy Workspace  

There is no direct API for copy workspace we have integrate combinations of API like import pbix, export pbix, Clone pbix.

Following code copy all the content of workspace to another workspace like report, dataset.

Power Shell Code For copy workspace



#### 4.4 Delete Group  

Deletes the specified workspace.

URL
https://api.powerbi.com/v1.0/myorg/groups/{groupId}

Power Shell Code for Delete workspace



#### 4.5 Delete User from Group  

Deletes the specified user permissions from the specified workspace.

URL
https://api.powerbi.com/v1.0/myorg/groups/{groupId}/users/{user}

Power Shell code for Delete User from Workspace




#### 4.6 Get Group Users  

Returns a list of users that have access to the specified workspace.

URL: https://api.powerbi.com/v1.0/myorg/groups/{groupId}/users

Power Shell Code for Get Users in Workspace



#### 4.7 Get Groups  

Returns a list of workspaces the user has access to.

URL : https://api.powerbi.com/v1.0/myorg/groups

You can also use filter in URL like below

https://api.powerbi.com/v1.0/myorg/groups?$filter=$filter=contains(name,'marketing')%20or%20name%20eq%20'contoso'

Power Shell code for Delete User in Workspace



# 5. Reports Operations using PowerShell

#### 5.1 Clone/Copy Report  

Clones the specified report from"My Workspace".
If after cloning the report and its dataset reside in two different upgraded workspace or "My Workspace", a shared dataset will be created in the report's workspace.
Reports with live connection will lose the live connection when cloning, and will have a direct binding to the target dataset.

URL: https://api.powerbi.com/v1.0/myorg/groups/{groupId}/users/{user}

Power Shell Code for Clone the report



#### 5.2 Delete Report  

Returns a list of workspaces the user has access to.

URL : https://api.powerbi.com/v1.0/myorg/groups

You can also use filter in URL like below

https://api.powerbi.com/v1.0/myorg/groups?$filter=$filter=contains(name,'marketing')%20or%20name%20eq%20'contoso'

Power Shell code for Delete User in Workspace



#### 5.3 Export Report  

Exports the specified report from "My Workspace" to a .pbix file. File will be exported in ZIP format.

Limitation:
Export of a report with Power BI service live connection after calling rebind report is not supported.

GET URL: https://api.powerbi.com/v1.0/myorg/reports/{reportId}/Export

Power Shell Code for Export the report



#### 5.4 Get Data sources In Group  

Returns a list of data sources for the specified RDL report from the specified workspace.

GET URL: https://api.powerbi.com/v1.0/myorg/groups/{groupId}/reports/{reportId}/datasources

Power Shell Code to Get Data sources the Group



#### 5.5 Get Report in Group  

Returns the specified report from the specified workspace.

GET URL : https://api.powerbi.com/v1.0/myorg/groups/{groupId}/reports/{reportId}

Power Shell Code for Get Report in Group




#### 5.6 Rebind Report  

Rebinds the specified report from the specified workspace to the requested dataset 
Reports with live connection will lose the live connection when rebinding, and will have direct 
binding to the target dataset.

GET URL: https://api.powerbi.com/v1.0/myorg/groups/{groupId}/reports/{reportId}/
Rebind

Power Shell Code for Rebind the Report



#### 5.7 Update Data sources  

Updates the data sources of the specified paginated report from the specified workspace. 
Important: The original data source and the new data source must have the exact same schema.

POST URL: https://api.powerbi.com/v1.0/myorg/groups/{groupId}/reports/{reportId}/Default.UpdateDatasources

Power Shell Code to Update Data source



# 6. Gateway Operations using PowerShell

#### 6.1 Create Data source  

Creates a new data source on the specified gateway.

POST URL: https://api.powerbi.com/v1.0/myorg/gateways/{gatewayId}/datasources

Power Shell Code to Create Data source


	
#### 6.2 Delete Data source  

Deletes the specified data source from the specified gateway

POST URL: 
https://api.powerbi.com/v1.0/myorg/gateways/{gatewayId}/datasources/{datasourceId}

Power Shell Code to Delete Data source




