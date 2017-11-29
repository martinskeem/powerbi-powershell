# powerbi-powershell
Various scripts and functions for harvesting Power BI meta data and automating Power BI tasks using API.

<h2>Prerequisites:</h2>

1. Create Azure AD app from portal.azure.com (see https://docs.microsoft.com/en-us/azure/active-directory/develop/active-directory-integrating-applications). Chose "Native" as the application type. Set Required Permissions for Power BI and with permissions according to whatever you plan to do.

2. Update values in AzureAdApp-Values.ps1 to reflect Azure AD app details (Application ID and Redirect URI)

3. Azure Active Directory Authentication Library needs to be installed


<h2>Files in solution:</h2>

<b>AzureAdApp-Values.ps1:</b> Static values containing Azure AD app values

<b>Get-GatewayStatus.ps1:</b> Check state of gateway and report to event log with version and hostname of the server that the gateway is currently mapped to. Report into event log as and error if gateway is not live, otherwise information event. Make sure to run <code>New-EventLog -Source "On-premises data gateway Check" -LogName "Application"</code> once as administrator before runnig script (this will create the source in the Application event log).

<b>Harvest-Metadata.ps1:</b> Harvests list of workspaces (and users), datasets (and sources + refresh history), gateways (and sources). This can be used to e.g. identify failed refreshes or refreshes runnig for excessively long (or often).

<b>powerbi_metadata.pbit:</b> Power BI Desktop template file to read data from files emitted by Harvest-Metadata.ps1. Also contains one report that shows dataset refreshes, status, time spent.

<b>Rebind-Report.ps1:</b> Bind a report to a new dataset, e.g. if changing an underlying data source from one server to another.

<b>Refresh-Dataset.ps1:</b> Refresh a dataset. Useful if trigger is not a specific time, but an event (e.g. a data warehouse batch done).

<b>PowerBI-Auth.ps1, PowerBI-Datasets.ps1, PowerBI-Gateways.ps1, PowerBI-Groups.ps1, PowerBI-Reports.ps1</b> contain functions for managing respective entities and used in files mentioned above.
