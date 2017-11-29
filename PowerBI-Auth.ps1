function Get-AuthToken
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [string] $ClientID,
        [Parameter(Mandatory=$true)]
        [string] $RedirectUri
    )

    $adal = "${env:ProgramFiles(x86)}\Microsoft SDKs\Azure\PowerShell\ServiceManagement\Azure\Services\Microsoft.IdentityModel.Clients.ActiveDirectory.dll"
    $adalforms = "${env:ProgramFiles(x86)}\Microsoft SDKs\Azure\PowerShell\ServiceManagement\Azure\Services\Microsoft.IdentityModel.Clients.ActiveDirectory.WindowsForms.dll"
 
    [System.Reflection.Assembly]::LoadFrom($adal) | Out-Null
    [System.Reflection.Assembly]::LoadFrom($adalforms) | Out-Null
 
    $authContext = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext" -ArgumentList "https://login.microsoftonline.com/common/oauth2/authorize"
    $authResult = $authContext.AcquireToken("https://analysis.windows.net/powerbi/api", $ClientID, $RedirectUri, "Auto")
 
    return $authResult
}

function Get-AuthorizationHeader
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [string] $ClientID,
        [Parameter(Mandatory=$true)]
        [string] $RedirectUri
    )

    $token = Get-AuthToken -ClientID $ClientID -RedirectUri $RedirectUri

    $authHeader = @{
        'Content-Type'='application/json'
        'Authorization'=$token.CreateAuthorizationHeader()
    }

    return $authHeader
}