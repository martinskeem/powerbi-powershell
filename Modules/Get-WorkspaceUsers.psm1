<# 
 .Synopsis
  Returns a list of users which are members of the workspace. Requires admin priviledges on that workspace.

 .Parameter AuthorizationHeader
  The OAuth token wrapped in a header. Can be obtained with Get-AuthorizationHeader.

 .Parameter WorkspaceID
  The WorkspaceID can be obtained with Get-Groups or from the URL on http://app.powerbi.com.

  .Example
  $users = Get-WorkspaceUsers -AuthorizationHeader $AuthorizationHeader -WorkspaceID "5103586a-09c6-460f-9179-19af296a72fc"
#>
function Get-WorkspaceUsers
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [System.Collections.IDictionary]$AuthorizationHeader,
        [Parameter(Mandatory=$true)]
        [String]$WorkspaceID
    )

    $uri = "https://api.powerbi.com/v1.0/myorg/groups/$WorkspaceID/users"

    $groupUsers = Invoke-RestMethod -Uri $uri -Headers $AuthorizationHeader -Method GET
    
    $groupUsers.value | Add-Member -NotePropertyName "group" -NotePropertyValue $WorkspaceID

    return $groupUsers.value
}