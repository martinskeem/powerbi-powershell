function Get-Gateway
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [System.Collections.IDictionary]$AuthorizationHeader,
        [Parameter(Mandatory=$true)]
        [String]$GatewayID
    )

    try
    {
        $uri = "https://api.powerbi.com/v1.0/myorg/gateways/$GatewayID"

        $dataSources = Invoke-RestMethod -Uri $uri -Headers $AuthorizationHeader -Method GET
    
        return $datasources
    }
    catch
    {
        Write-Warning "Error while retrieving info for gateway '$GatewayID': $($_.Exception.Message)"

        return $null
    }
}