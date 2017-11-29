function Get-Groups
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

function Get-GroupUsers
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [System.Collections.IDictionary]$AuthorizationHeader,
        [Parameter(Mandatory=$true)]
        [String]$GroupID
    )

    $uri = "https://api.powerbi.com/v1.0/myorg/groups/$GroupID/users"

    $groupUsers = Invoke-RestMethod -Uri $uri -Headers $AuthorizationHeader -Method GET
    
    $groupUsers.value | Add-Member -NotePropertyName "group" -NotePropertyValue $GroupID

    return $groupUsers.value
}