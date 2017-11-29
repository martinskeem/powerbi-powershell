# powerbi-powershell
Various scripts and functions for harvesting Power BI meta data and automating Power BI tasks using API.

<h2>Prerequisites:</h2>

1. Create Azure AD app from portal.azure.com (see https://docs.microsoft.com/en-us/azure/active-directory/develop/active-directory-integrating-applications). Chose "Native" as the application type. Set Required Permissions for Power BI and with permissions according to whatever you plan to do.

2. Update values in AzureAdApp-Values.ps1 to reflect Azure AD app details (Application ID and Redirect URI)

3. Azure Active Directory Authentication Library needs to be installed


<h2>Files in solution:</h2>

<b>AzureAdApp-Values.ps1:</b> static values containing Azure AD app values

<b>Get-GatewayStatus.ps1:</b> check status of gateway and report to event log with version and host it runs on. Error if not live.

<b>Harvest-Metadata.ps1:</b> harvest list of workspaces (and users), datasets (and sources + refresh history), gateways (and sources)

<b>powerbi_metadata.pbit:</b> Power BI Desktop template file to read data outputted from Harvest-Metadata. Example report that shows dataset refreshes, status, time spent.

<b>Rebind-Report.ps1:</b> bind a report to a new dataset

<b>Refresh-Dataset.ps1:</b> refresh a dataset

<b>PowerBI-Auth.ps1, PowerBI-Datasets.ps1, PowerBI-Gateways.ps1, PowerBI-Groups.ps1, PowerBI-Reports.ps1</b> contain functions for managing respective entities.
