function Get-GatewayDataSources
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
        $uri = "https://api.powerbi.com/v1.0/myorg/gateways/$GatewayID/dataSources"

        $dataSources = Invoke-RestMethod -Uri $uri -Headers $AuthorizationHeader -Method GET
    
        $dataSources.value | Add-Member -NotePropertyName "gateway" -NotePropertyValue $GatewayID

        return $datasources.value
    }
    catch
    {
        Write-Warning "Error while retrieving data sources for '$GatewayID': $($_.Exception.Message)"

        return $null
    }
}