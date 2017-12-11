function Set-ReportBinding
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [System.Collections.IDictionary]$AuthorizationHeader,
        [Parameter(Mandatory=$true)]
        [String]$WorkspaceID,
        [Parameter(Mandatory=$true)]
        [String]$ReportID,
        [Parameter(Mandatory=$true)]
        [String]$NewDatasetID
    )

    try
    {
        $uri = "https://api.powerbi.com/v1.0/myorg/groups/$WorkspaceID/reports/$ReportID/Rebind"

        Invoke-RestMethod -Uri $uri -Headers $AuthorizationHeader -Method Post -Body "{'datasetId':'$NewDatasetID'}"
    }
    catch
    {
        Write-Warning "Error while rebinding report '$ReportID' in '$WorkspaceID': $($_.Exception.Message)"

        return $null
    }
}