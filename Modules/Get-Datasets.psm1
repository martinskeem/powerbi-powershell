function Get-Datasets
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [System.Collections.IDictionary]$AuthorizationHeader,
        [Parameter(Mandatory=$true)]
        [String]$WorkspaceID
    )

    try
    {
        $uri = "https://api.powerbi.com/v1.0/myorg/groups/$WorkspaceID/datasets"

        $datasets = Invoke-RestMethod -Uri $uri -Headers $AuthorizationHeader -Method GET
    
        $datasets.value | Add-Member -NotePropertyName "group" -NotePropertyValue $WorkspaceID

        return $datasets.value
    }
    catch
    {
        Write-Warning "Error while enumerating datasets in '$WorkspaceID': $($_.Exception.Message)"

        return $null
    }
}