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