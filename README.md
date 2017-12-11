# powerbi-powershell
Various scripts and functions for harvesting Power BI meta data and automating Power BI tasks using API.

## Prerequisites

1. Create Azure AD app from portal.azure.com (see [documentation](https://docs.microsoft.com/en-us/azure/active-directory/develop/active-directory-integrating-applications)). Chose "Native" as the application type. Set Required Permissions for Power BI and with permissions which will at least support whatever you are planning to do with this application.

2. "Azure Active Directory Authentication Library" needs to be installed prior to running any of the scripts.
