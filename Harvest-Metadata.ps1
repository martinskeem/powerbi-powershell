(New-Object System.Net.WebClient).Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials

. "$PSScriptRoot\AzureAdApp-Values.ps1"
. "$PSScriptRoot\PowerBI-Auth.ps1"
. "$PSScriptRoot\PowerBI-Groups.ps1"
. "$PSScriptRoot\PowerBI-Datasets.ps1"
. "$PSScriptRoot\PowerBI-Gateways.ps1"

$outputRoot = "C:\temp\power bi meta" # folder to place meta data in

$groupsFile = "$outputRoot\groups.csv"
$groupUsersFile = "$outputRoot\group_users.csv"
$datasetsFile = "$outputRoot\group_datasets.csv"
$datasetRefreshesFile = "$outputRoot\group_dataset_refreshes.csv"
$datasetSourcesFile = "$outputRoot\group_dataset_boundsources.csv"
$gatewaysFile = "$outputRoot\gateways.csv"
$gatewayDatasourcesFile = "$outputRoot\gateway_datasources.csv"

$authHeader = Get-AuthorizationHeader -ClientId $clientId -RedirectUri $redirectUri

Remove-Item -Path $groupsFile -ErrorAction SilentlyContinue
Remove-Item -Path $groupUsersFile -ErrorAction SilentlyContinue
Remove-Item -Path $datasetsFile -ErrorAction SilentlyContinue
Remove-Item -Path $datasetRefreshesFile -ErrorAction SilentlyContinue
Remove-Item -Path $datasetSourcesFile -ErrorAction SilentlyContinue
Remove-Item -Path $gatewaysFile -ErrorAction SilentlyContinue
Remove-Item -Path $gatewayDatasourcesFile -ErrorAction SilentlyContinue

$groups = Get-Groups -AuthorizationHeader $authHeader
$groups | Export-Csv -Path $groupsFile -Encoding UTF8 -NoTypeInformation

# gateways
$gateways = Get-Gateways -AuthorizationHeader $authHeader

ForEach($gateway in $gateways) {
    $gatewayDetails = Get-Gateway -GatewayID $gateway.id -AuthorizationHeader $authHeader
    $gatewayDetails | Export-Csv -Path $gatewaysFile -Encoding UTF8 -NoTypeInformation -Append -Force
    
    $datasources = Get-GatewayDataSources -AuthorizationHeader $authHeader -GatewayID $gateway.id
    $datasources | Export-Csv -Path $gatewayDatasourcesFile -Encoding UTF8 -NoTypeInformation -Append -Force
}

# iterate workspaces
ForEach($group in $groups) {
    # append to users
    $groupUsers = Get-GroupUsers -AuthorizationHeader $authHeader -GroupID $group.id
    $groupUsers | Export-csv -Path $groupUsersFile -Encoding UTF8 -NoTypeInformation -Append

    # foreach dataset in workspace
    $datasets = Get-Datasets -AuthorizationHeader $authHeader -GroupID $group.id
    if($datasets -ne $null) {
        $datasets | Export-Csv -Path $datasetsFile -Encoding UTF8 -NoTypeInformation -Append

        ForEach($dataset in $datasets) {
            If($dataset.isRefreshable) {
                $refreshes = Get-DatasetRefreshHistory -AuthorizationHeader $authHeader -GroupID $group.id -DatasetID $dataset.id

                # append refresh history
                if($refreshes -ne $null) {
                    $refreshes | Export-Csv -Path $datasetRefreshesFile -Encoding UTF8 -NoTypeInformation -Append -Force
                }
            }

            # get bound datasources
            $sources = Get-DatasetBoundSources -AuthorizationHeader $authHeader -GroupID $group.id -DatasetID $dataset.id

            if($sources -ne $null) {
                $sources | Export-Csv -Path $datasetSourcesFile -Encoding UTF8 -NoTypeInformation -Append
            }
        }
    }
}
