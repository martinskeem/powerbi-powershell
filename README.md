# powerbi-powershell
Various scripts and functions for harvesting Power BI meta data and automating Power BI tasks using API.

## Prerequisites

1. Create Azure AD app from https://portal.azure.com (see [documentation](https://docs.microsoft.com/en-us/azure/active-directory/develop/active-directory-integrating-applications)). Chose "Native" as the application type. Set Required Permissions for Power BI and with permissions which will at least support whatever you are planning to do. You can also create an application from [here](https://dev.powerbi.com/apps), but not all permissions will be enabled by default (e.g. access to enumerate gateways).

2. Azure PowerShell needs to be installed prior to running any of the scripts. Install from [here](https://github.com/Azure/azure-powershell/releases/latest) or [here](https://azure.microsoft.com/downloads/)

## Examples

### Refresh a dataset
In a setting where a dataset is based on a data source such as a data warehouse that is batch loaded daily and which is not necessarily ready at a specific time of the day, it will be necessary to refresh datasets triggered by this completion - rather than a specific time.

This can be achieved by executing below after e.g. a data warheouse load. It could easily be extended to iterate datasets in a number of workspaces and start off those that use a specific source:

```powershell
$clientId = "" # The ID of the Application ID of the App Registration in Azure AD
$redirectUri = "" # One of the redirect URIs provided in the App Registration in Azure AD
$workspaceId = "" # insert workspace id of dataset here (get from url on app.powerbi.com)
$datasetId = "" # insert dataset id here (get from url on app.powerbi.com)

$authHeader = Get-AuthorizationHeader -ClientId $clientId -RedirectUri $redirectUri

Update-Dataset -AuthorizationHeader $authHeader -GroupID $workspaceId -DatasetID $datasetId
```

### Harvest meta data to CSV files
It is possible to iterate Power BI entities (gateways, workspaces, users, datasets, refresh logs etc.) and extract this. 

This can then be used to create reporting on - e.g. to monitor scheduled datasets that takes excessively long to execute or runs excessively often. This can be useful in a self-service environment and in particular if using a (costly) Premium capacity. E.g:

![Refresh Log](https://github.com/martinskeem/powerbi-powershell/blob/master/Assets/refresh-log.png "Refresh Log")

Below script will harvest data to CSV files, which can then be read into a Power BI dataset:

```powershell
$clientId = "" # The ID of the Application ID of the App Registration in Azure AD
$redirectUri = "" # One of the redirect URIs provided in the App Registration in Azure AD
$outputRoot = "" # folder to place meta data in

$workspacesFile = "$outputRoot\workspaces.csv"
$workspaceUsersFile = "$outputRoot\workspace_users.csv"
$datasetsFile = "$outputRoot\workspace_datasets.csv"
$datasetRefreshesFile = "$outputRoot\workspace_dataset_refreshes.csv"
$datasetSourcesFile = "$outputRoot\workspace_dataset_boundsources.csv"
$gatewaysFile = "$outputRoot\gateways.csv"
$gatewayDatasourcesFile = "$outputRoot\gateway_datasources.csv"

$authHeader = Get-AuthorizationHeader -ClientId $clientId -RedirectUri $redirectUri

Remove-Item -Path $workspacesFile -ErrorAction SilentlyContinue
Remove-Item -Path $workspaceUsersFile -ErrorAction SilentlyContinue
Remove-Item -Path $datasetsFile -ErrorAction SilentlyContinue
Remove-Item -Path $datasetRefreshesFile -ErrorAction SilentlyContinue
Remove-Item -Path $datasetSourcesFile -ErrorAction SilentlyContinue
Remove-Item -Path $gatewaysFile -ErrorAction SilentlyContinue
Remove-Item -Path $gatewayDatasourcesFile -ErrorAction SilentlyContinue

$workspaces = Get-Workspaces -AuthorizationHeader $authHeader
$workspaces | Export-Csv -Path $workspacesFile -Encoding UTF8 -NoTypeInformation

# gateways
$gateways = Get-Gateways -AuthorizationHeader $authHeader

ForEach($gateway in $gateways) {
    $gatewayDetails = Get-Gateway -GatewayID $gateway.id -AuthorizationHeader $authHeader
    $gatewayDetails | Export-Csv -Path $gatewaysFile -Encoding UTF8 -NoTypeInformation -Append -Force
    
    $datasources = Get-GatewayDataSources -AuthorizationHeader $authHeader -GatewayID $gateway.id
    $datasources | Export-Csv -Path $gatewayDatasourcesFile -Encoding UTF8 -NoTypeInformation -Append -Force
}

# iterate workspaces
ForEach($workspace in $workspaces) {
    # append to users
    $workspaceUsers = Get-WorkspaceUsers -AuthorizationHeader $authHeader -WorkspaceID $workspace.id
    $workspaceUsers | Export-csv -Path $workspaceUsersFile -Encoding UTF8 -NoTypeInformation -Append

    # foreach dataset in workspace
    $datasets = Get-Datasets -AuthorizationHeader $authHeader -WorkspaceID $workspace.id
    if($datasets -ne $null) {
        $datasets | Export-Csv -Path $datasetsFile -Encoding UTF8 -NoTypeInformation -Append

        ForEach($dataset in $datasets) {
            If($dataset.isRefreshable) {
                $refreshes = Get-DatasetRefreshHistory -AuthorizationHeader $authHeader -WorkspaceID $workspace.id -DatasetID $dataset.id

                # append refresh history
                if($refreshes -ne $null) {
                    $refreshes | Export-Csv -Path $datasetRefreshesFile -Encoding UTF8 -NoTypeInformation -Append -Force
                }
            }

            # get bound datasources
            $sources = Get-DatasetBoundSources -AuthorizationHeader $authHeader -WorkspaceID $workspace.id -DatasetID $dataset.id

            if($sources -ne $null) {
                $sources | Export-Csv -Path $datasetSourcesFile -Encoding UTF8 -NoTypeInformation -Append
            }
        }
    }
}
```

### Change data source of a dataset
In the event a server name changes - of e.g. an Analysis Services database - it may be necessary to change the data source of a number of datasets programatically. This can be achieved using this code:

```powershell
$clientId = "" # The ID of the Application ID of the App Registration in Azure AD
$redirectUri = "" # One of the redirect URIs provided in the App Registration in Azure AD
$workspaceId = "" # set workspace ID of report (get from app.powerbi.com url)
$reportId = "" # set report ID (get from app.powerbi.com url)
$newDatasetId = "" # set ID of new dataset (get from app.powerbi.com)

$authHeader = Get-AuthorizationHeader -ClientId $clientId -RedirectUri $redirectUri
Set-ReportBinding -GroupID $workspaceId -ReportID $reportId -NewDatasetID $newDatasetId -AuthorizationHeader $authHeader
```

### Report gateway status to event log
A typical production requirement might be to implement some sort of surveillance of the gateway. Below sample will report current activity state of gateway (active, inactive) into the Application Event Log, which then, in turn could be monitored by a central function.

Before the first time the script is executed, the event log source must be created using:
```powershell
New-EventLog -Source "On-premises data gateway Check" -LogName "Application"
```

Once the source is created, below can be scheduled to run e.g. every 5 minutes after filling in the gateway name and details of the Azure AD app.

```powershell
$gatewayName = "" # insert name of Gateway to check here.
$clientId = "" # The ID of the Application ID of the App Registration in Azure AD
$redirectUri = "" # One of the redirect URIs provided in the App Registration in Azure AD

$authHeader = Get-AuthorizationHeader -ClientId $clientId -RedirectUri $redirectUri

$gateways = Get-Gateways -AuthorizationHeader $authHeader | Where-Object -Property "name" -EQ $gatewayName

if($gateways.Count -eq 0) {
    Write-EventLog -LogName "Application" -Source "On-premises data gateway Check" -EventId 1000 -EntryType Error -Message "Gateway '$gatewayName'  does not exist."
}

$gateways | ForEach-Object {
    $gateway = Get-Gateway -GatewayID $_.id -AuthorizationHeader $authHeader
    $annotation = $gateway.gatewayAnnotation | ConvertFrom-Json

    if ($gateway.gatewayStatus -eq "Live") {
        Write-EventLog -LogName "Application" -Source "On-premises data gateway Check" -EventId 1000 -EntryType Information -Message "Status of '$($gateway.name)' is '$($gateway.gatewayStatus)'. Running on '$($annotation.gatewayMachine)'. Version '$($annotation.gatewayVersion)'"
    } else {
        Write-EventLog -LogName "Application" -Source "On-premises data gateway Check" -EventId 1000 -EntryType Error -Message "Status of '$($gateway.name)' is '$($gateway.gatewayStatus)'. Running on '$($annotation.gatewayMachine)'. Version '$($annotation.gatewayVersion)'"
    }
}
```
