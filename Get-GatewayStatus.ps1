(New-Object System.Net.WebClient).Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials

# RUN ONCE AS ADMIN 
# New-EventLog -Source "On-premises data gateway Check" -LogName "Application"

. "$PSScriptRoot\PowerBI-Auth.ps1"
. "$PSScriptRoot\PowerBI-Gateways.ps1"
. "$PSScriptRoot\AzureAdApp-Values.ps1"

$gatewayName = "Saxo Bank Internal" # insert name of Gateway to check here.

$authHeader = Get-AuthorizationHeader -ClientId $clientId -RedirectUri $redirectUri

$gateways = Get-Gateways -AuthorizationHeader $authHeader | Where-Object -Property "name" -EQ $gatewayName

if($gateways.Count -eq 0) {
    Write-EventLog -LogName "Application" -Source "On-premises data gateway Check" -EventId 1000 -EntryType Error -Message "Gateway '$gatewayName'  does not exist."
}

$gateways | ForEach-Object {
    $gateway = Get-Gateway -GatewayID $_.id -AuthorizationHeader $authHeader
    $annotation = $gateway.gatewayAnnotation | ConvertFrom-Json

    if ($gateway.gatewayStatus -eq "Live") {
        Write-EventLog -LogName "Application" -Source "On-premises data gateway Check" -EventId 1000 -EntryType Information -Message "Status of '$($gateway.name)' is '$($gateway.gatewayStatus)'. Running on '$($annotation.gatewayMachine)'. Version '$($annotation.gatewayVersion)'"
    } else {
        Write-EventLog -LogName "Application" -Source "On-premises data gateway Check" -EventId 1000 -EntryType Error -Message "Status of '$($gateway.name)' is '$($gateway.gatewayStatus)'. Running on '$($annotation.gatewayMachine)'. Version '$($annotation.gatewayVersion)'"
    }
}