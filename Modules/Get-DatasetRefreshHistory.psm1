function Get-DatasetRefreshHistory
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
        $uri = "https://api.powerbi.com/v1.0/myorg/groups/$WorkspaceID/datasets/$DatasetID/refreshes/?`$top=10"

        $datasetRefreshes = Invoke-RestMethod -Uri $uri -Headers $AuthorizationHeader -Method GET
    
        $datasetRefreshes.value | Add-Member -NotePropertyName "group" -NotePropertyValue $WorkspaceID
        $datasetRefreshes.value | Add-Member -NotePropertyName "dataset" -NotePropertyValue $DatasetID

        return $datasetRefreshes.value
    }
    catch
    {
        Write-Warning "Error while retrieving refresh history for '$DatasetID': $($_.Exception.Message)"

        return $null
    }
}