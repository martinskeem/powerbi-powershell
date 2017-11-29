# powerbi-powershell
Various scripts and functions for harvesting Power BI meta data and automating Power BI tasks using API.

## Prerequisites

1. Create Azure AD app from portal.azure.com (see https://docs.microsoft.com/en-us/azure/active-directory/develop/active-directory-integrating-applications). Chose "Native" as the application type. Set Required Permissions for Power BI and with permissions which will at least support whatever you are planning to do with this application.

2. Update values in AzureAdApp-Values.ps1 to reflect Azure AD app details (Application ID and Redirect URI of app created in step 1)

3. "Azure Active Directory Authentication Library" needs to be installed prior to running any of the scripts.

## Files
| **File** | **Description**|
|---|---|
|[AzureAdApp-Values.ps1](https://github.com/martinskeem/powerbi-powershell/blob/master/AzureAdApp-Values.ps1)|Static values containing Azure AD app values|
|[Get-GatewayStatus.ps1](https://github.com/martinskeem/powerbi-powershell/blob/master/Get-GatewayStatus.ps1)|Check state of gateway and report to event log with version and hostname of the server that the gateway is currently mapped to. Report into event log as and error if gateway is not live, otherwise information event. Make sure to run `New-EventLog -Source "On-premises data gateway Check" -LogName "Application"` once as administrator before runnig script (this will create the source in the Application event log).|
|[Harvest-Metadata.ps1](https://github.com/martinskeem/powerbi-powershell/blob/master/Harvest-Metadata.ps1)|Harvests list of workspaces (and users), datasets (and sources + refresh history), gateways (and sources). This can be used to e.g. identify failed refreshes or refreshes runnig for excessively long (or often).|
|[powerbi_metadata.pbit](https://github.com/martinskeem/powerbi-powershell/blob/master/powerbi_metadata.pbit)|Power BI Desktop template file to read data from files emitted by Harvest-Metadata.ps1. Also contains one report that shows dataset refreshes, status, time spent.|
|[Rebind-Report.ps1](https://github.com/martinskeem/powerbi-powershell/blob/master/Rebind-Report.ps1)|Bind a report to a new dataset, e.g. if changing an underlying data source from one server to another.|
|[Refresh-Dataset.ps1](https://github.com/martinskeem/powerbi-powershell/blob/master/Refresh-Dataset.ps1)|Refresh a dataset. Useful if trigger is not a specific time, but an event (e.g. a data warehouse batch done).|
|[PowerBI-Auth.ps1](https://github.com/martinskeem/powerbi-powershell/blob/master/PowerBI-Auth.ps1)|Functions for authenticating against Azure AD|
|[PowerBI-Datasets.ps1](https://github.com/martinskeem/powerbi-powershell/blob/master/PowerBI-Datasets.ps1)|Helper functions for managing datasets|
|[PowerBI-Gateways.ps1](https://github.com/martinskeem/powerbi-powershell/blob/master/PowerBI-Gateways.ps1)|Helper functions for managing gateways|
|[PowerBI-Groups.ps1](https://github.com/martinskeem/powerbi-powershell/blob/master/PowerBI-Groups.ps1)|Helper functions for managing workspaces|
|[PowerBI-Reports.ps1](https://github.com/martinskeem/powerbi-powershell/blob/master/PowerBI-Reports.ps1)|Helper functions for managing reports|
