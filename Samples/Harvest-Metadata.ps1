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
