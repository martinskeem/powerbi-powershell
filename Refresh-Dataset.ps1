(New-Object System.Net.WebClient).Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials

. "$PSScriptRoot\AzureAdApp-Values.ps1"
. "$PSScriptRoot\PowerBI-Auth.ps1"
. "$PSScriptRoot\PowerBI-Reports.ps1"

$workspaceId = "" # set workspace ID of report (get from app.powerbi.com url)
$reportId = "" # set report ID (get from app.powerbi.com url)
$newDatasetId = "" # set ID of new dataset (get from app.powerbi.com)

$authHeader = Get-AuthorizationHeader -ClientId $clientId -RedirectUri $redirectUri
Set-ReportBinding -GroupID $workspaceId -ReportID $reportId -NewDatasetID $newDatasetId -AuthorizationHeader $authHeader
