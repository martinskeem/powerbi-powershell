function Get-AuthTokenFromServicePrincipal
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [string] $ClientID,
        [Parameter(Mandatory=$true)]
        [string] $Secret
    )

    $adal = "${env:ProgramFiles(x86)}\Microsoft SDKs\Azure\PowerShell\ServiceManagement\Azure\Services\Microsoft.IdentityModel.Clients.ActiveDirectory.dll"
 
    [System.Reflection.Assembly]::LoadFrom($adal) | Out-Null

    $clientcredential = New-Object -TypeName Microsoft.IdentityModel.Clients.ActiveDirectory.ClientCredential  -ArgumentList $ClientID, $Secret

    $authContext = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext" -ArgumentList "https://login.microsoftonline.com/3f548be2-31e9-4681-839e-bc80d461f367/common/oauth2/authorize"
    $authResult = $authContext.AcquireToken("https://analysis.windows.net/powerbi/api", $clientcredential)
 
    return $authResult
}