function Update-DatasetData
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
        $uri = "https://api.powerbi.com/v1.0/myorg/groups/$WorkspaceID/datasets/$DatasetID/refreshes"

        Invoke-RestMethod -Uri $uri -Headers $AuthorizationHeader -Method Post
    }
    catch
    {
        Write-Warning -Message "Error while refreshing dataset '$DatasetID': $($_.Exception.Message)"

        return $null
    }
    
}