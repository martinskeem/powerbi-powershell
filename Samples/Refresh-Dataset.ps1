$workspaceId = "" # insert workspace id of dataset here (get from url on app.powerbi.com)
$datasetId = "" # insert dataset id here (get from url on app.powerbi.com)

$authHeader = Get-AuthorizationHeader -ClientId $clientId -RedirectUri $redirectUri

Update-Dataset -AuthorizationHeader $authHeader -GroupID $workspaceId -DatasetID $datasetId
