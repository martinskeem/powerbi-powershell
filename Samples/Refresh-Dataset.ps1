(New-Object System.Net.WebClient).Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials

. "$PSScriptRoot\AzureAdApp-Values.ps1"
. "$PSScriptRoot\PowerBI-Auth.ps1"
. "$PSScriptRoot\PowerBI-Datasets.ps1"

$workspaceId = "" # insert workspace id of dataset here (get from url on app.powerbi.com)
$datasetId = "" # insert dataset id here (get from url on app.powerbi.com)

$authHeader = Get-AuthorizationHeader -ClientId $clientId -RedirectUri $redirectUri

Update-Dataset -AuthorizationHeader $authHeader -GroupID $workspaceId -DatasetID $datasetId
