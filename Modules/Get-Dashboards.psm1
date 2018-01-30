<# 
 .Synopsis
  Returns a list of dashboards within a workspace.

 .Parameter AuthorizationHeader
  The OAuth token wrapped in a header. Can be obtained with Get-AuthorizationHeader.

 .Parameter WorkspaceID
  The ID of the workspace which you would like to list dashboards for

 .Example
  $dashboards = Get-Dashboards -AuthorizationHeader $AuthorizationHeader -WorkspaceID $WorkspaceID
#>
function Get-Dashboards
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [System.Collections.IDictionary]$AuthorizationHeader,
        [Parameter(Mandatory=$true)]
        [String]$WorkspaceID        
    )

    $uri = "https://api.powerbi.com/v1.0/myorg/groups/$WorkspaceID/dashboards"

    $dashboards = Invoke-RestMethod -Uri $uri -Headers $AuthorizationHeader -Method GET

    return $dashboards.value
}