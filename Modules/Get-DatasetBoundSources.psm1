function Get-DatasetBoundSources
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [System.Collections.IDictionary]$AuthorizationHeader,
        [Parameter(Mandatory=$true)]
        [String]$WorkspaceID,
        [Parameter(Mandatory=$true)]
        [String]$DatasetID
    )

    try
    {
        $uri = "https://api.powerbi.com/v1.0/myorg/groups/$WorkspaceID/datasets/$DatasetID/Default.GetBoundGatewayDataSources"

        $datasetSources = Invoke-RestMethod -Uri $uri -Headers $AuthorizationHeader -Method GET
    
        $datasetSources.value | Add-Member -NotePropertyName "group" -NotePropertyValue $WorkspaceID
        $datasetSources.value | Add-Member -NotePropertyName "dataset" -NotePropertyValue $DatasetID

        return $datasetSources.value
    }
    catch
    {
        Write-Warning -Message "Error while retrieving data sources for '$DatasetID': $($_.Exception.Message)"

        return $null
    }
}