<# 
 .Synopsis
  Returns a list of reports within a workspace.

 .Parameter AuthorizationHeader
  The OAuth token wrapped in a header. Can be obtained with Get-AuthorizationHeader.

 .Parameter WorkspaceID
  The ID of the workspace which you would like to list reports for

 .Example
  $reports = Get-Reports -AuthorizationHeader $AuthorizationHeader -WorkspaceID $WorkspaceID
#>
function Get-Reports
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [System.Collections.IDictionary]$AuthorizationHeader,
        [Parameter(Mandatory=$true)]
        [String]$WorkspaceID        
    )

    $uri = "https://api.powerbi.com/v1.0/myorg/groups/$WorkspaceID/reports"

    $reports = Invoke-RestMethod -Uri $uri -Headers $AuthorizationHeader -Method GET

    return $reports.value
}