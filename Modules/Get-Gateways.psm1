function Get-Gateways
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [System.Collections.IDictionary]$AuthorizationHeader
    )

    try
    {
        $uri = "https://api.powerbi.com/v1.0/myorg/gateways"

        $gateways = Invoke-RestMethod -Uri $uri -Headers $AuthorizationHeader -Method GET
    
        return $gateways.value
    }
    catch
    {
        Write-Warning "Error while getting gatways: $($_.Exception.Message)"
        
        throw $_.Exception

        return $null
    }
}