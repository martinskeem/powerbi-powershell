<# 
 .Synopsis
  Acquires authentication token and wraps it into a header formed in the way expected by Power BI APIs.

 .Parameter ClientID
  The ID of the Application ID of the App Registration in Azure AD.

 .Parameter RedirectUri
  One of the redirect URIs provided in the App Registration in Azure AD.

 .Example
  $authenticationHeader = Get-AuthorizationHeader -ClientID "a3d8e0c4-d1f4-45d9-4031-e2a596c199fd" -RedirectUri "https://www.some-redirect-uri.com"
#>
function Get-AuthorizationHeader
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [string] $ClientID,
        [Parameter(Mandatory=$true)]
        [string] $RedirectUri,
        [Parameter(Mandatory=$false)]
        [string] $PromptBehavior = "Auto"    
    )

    $token = Get-AuthToken -ClientID $ClientID -RedirectUri $RedirectUri -PromptBehavior $PromptBehavior

    $authHeader = @{
        'Content-Type'='application/json'
        'Authorization'=$token.CreateAuthorizationHeader()
    }

    return $authHeader
}