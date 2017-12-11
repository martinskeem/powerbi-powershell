<# 
 .Synopsis
  Uses Azure Active Directory Authentication Libraries to acquire token that allows this module to access data in tenant.

 .Parameter ClientID
  The ID of the Application ID of the App Registration in Azure AD.

 .Parameter RedirectUri
  One of the redirect URIs provided in the App Registration in Azure AD.

 .Example
  $authToken = Get-AuthToken -ClientID "a3d8e0c4-d1f4-45d9-4031-e2a596c199fd" -RedirectUri "https://www.some-redirect-uri.com"
#>
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