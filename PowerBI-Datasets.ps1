function Get-Datasets
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [System.Collections.IDictionary]$AuthorizationHeader,
        [Parameter(Mandatory=$true)]
        [String]$GroupID
    )

    try
    {
        $uri = "https://api.powerbi.com/v1.0/myorg/groups/$GroupID/datasets"

        $datasets = Invoke-RestMethod -Uri $uri -Headers $AuthorizationHeader -Method GET
    
        $datasets.value | Add-Member -NotePropertyName "group" -NotePropertyValue $GroupID

        return $datasets.value
    }
    catch
    {
        Write-Warning "Error while enumerating datasets in '$GroupID': $($_.Exception.Message)"

        return $null
    }
}

function Get-DatasetRefreshHistory
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [System.Collections.IDictionary]$AuthorizationHeader,
        [Parameter(Mandatory=$true)]
        [String]$GroupID,
        [Parameter(Mandatory=$true)]
        [String]$DatasetID
    )

    try
    {
        $uri = "https://api.powerbi.com/v1.0/myorg/groups/$GroupID/datasets/$DatasetID/refreshes/?`$top=10"

        $datasetRefreshes = Invoke-RestMethod -Uri $uri -Headers $AuthorizationHeader -Method GET
    
        $datasetRefreshes.value | Add-Member -NotePropertyName "group" -NotePropertyValue $GroupID
        $datasetRefreshes.value | Add-Member -NotePropertyName "dataset" -NotePropertyValue $DatasetID

        return $datasetRefreshes.value
    }
    catch
    {
        Write-Warning "Error while retrieving refresh history for '$DatasetID': $($_.Exception.Message)"

        return $null
    }
}

function Get-DatasetBoundSources
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [System.Collections.IDictionary]$AuthorizationHeader,
        [Parameter(Mandatory=$true)]
        [String]$GroupID,
        [Parameter(Mandatory=$true)]
        [String]$DatasetID
    )

    try
    {
        $uri = "https://api.powerbi.com/v1.0/myorg/groups/$GroupID/datasets/$DatasetID/Default.GetBoundGatewayDataSources"

        $datasetSources = Invoke-RestMethod -Uri $uri -Headers $AuthorizationHeader -Method GET
    
        $datasetSources.value | Add-Member -NotePropertyName "group" -NotePropertyValue $GroupID
        $datasetSources.value | Add-Member -NotePropertyName "dataset" -NotePropertyValue $DatasetID

        return $datasetSources.value
    }
    catch
    {
        Write-Warning -Message "Error while retrieving data sources for '$DatasetID': $($_.Exception.Message)"

        return $null
    }
}

function Update-Dataset
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [System.Collections.IDictionary]$AuthorizationHeader,
        [Parameter(Mandatory=$true)]
        [String]$GroupID,
        [Parameter(Mandatory=$true)]
        [String]$DatasetID
    )

    try
    {
        $uri = "https://api.powerbi.com/v1.0/myorg/groups/$GroupID/datasets/$DatasetID/refreshes"

        Invoke-RestMethod -Uri $uri -Headers $AuthorizationHeader -Method Post
    }
    catch
    {
        Write-Warning -Message "Error while refreshing dataset '$DatasetID': $($_.Exception.Message)"

        return $null
    }
    
}