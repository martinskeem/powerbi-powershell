$clientId = "" # The ID of the Application ID of the App Registration in Azure AD
$redirectUri = "" # One of the redirect URIs provided in the App Registration in Azure AD
$workspaceId = "" # set workspace ID of report (get from app.powerbi.com url)
$reportId = "" # set report ID (get from app.powerbi.com url)
$newDatasetId = "" # set ID of new dataset (get from app.powerbi.com)

$authHeader = Get-AuthorizationHeader -ClientId $clientId -RedirectUri $redirectUri
Set-ReportBinding -GroupID $workspaceId -ReportID $reportId -NewDatasetID $newDatasetId -AuthorizationHeader $authHeader