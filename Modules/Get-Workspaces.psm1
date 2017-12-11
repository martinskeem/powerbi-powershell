<# 
 .Synopsis
  Returns a list of workspaces which the executing user has access to see.

 .Parameter AuthorizationHeader
  The OAuth token wrapped in a header. Can be obtained with Get-AuthorizationHeader.

 .Example
  $workspaces = Get-Groups -AuthorizationHeader $AuthorizationHeader
#>
function Get-Workspaces
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [System.Collections.IDictionary]$AuthorizationHeader
    )

    $uri = "https://api.powerbi.com/v1.0/myorg/groups"

    $groups = Invoke-RestMethod -Uri $uri -Headers $AuthorizationHeader -Method GET

    return $groups.value
}