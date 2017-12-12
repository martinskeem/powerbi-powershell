# RUN ONCE AS ADMIN 
# New-EventLog -Source "On-premises data gateway Check" -LogName "Application"

$clientId = "" # The ID of the Application ID of the App Registration in Azure AD
$redirectUri = "" # One of the redirect URIs provided in the App Registration in Azure AD
$gatewayName = "" # insert name of Gateway to check here.

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