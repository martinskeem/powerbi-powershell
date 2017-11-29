(New-Object System.Net.WebClient).Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials

. "$PSScriptRoot\PowerBI-Auth.ps1"
. "$PSScriptRoot\PowerBI-Datasets.ps1"

$clientId = "" # insert ID of Azure AD App here.
$redirectUri = "" # insert Redirect URI of Azure AD App here.
$workspaceId = "" # insert workspace id of dataset here (get from url on app.powerbi.com)
$datasetId = "" # insert dataset id here (get from url on app.powerbi.com)

$authHeader = Get-AuthorizationHeader -ClientId $clientId -RedirectUri $redirectUri

Update-Dataset -AuthorizationHeader $authHeader -GroupID $workspaceId -DatasetID $datasetId