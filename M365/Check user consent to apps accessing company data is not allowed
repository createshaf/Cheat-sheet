#user consent to apps accessing company data on their behalf is not allowed
Import-Module Microsoft.Graph.Authentication
Import-Module Microsoft.Graph.Identity.SignIns

# Connect to Microsoft Graph if not already connected
if (-not (Get-MgContext)) {
    Connect-MgGraph -Scopes "Policy.Read.All"
}

# Get the authorization policy
$authPolicy = Get-MgPolicyAuthorizationPolicy -ErrorAction SilentlyContinue

if (-not $authPolicy -or $authPolicy.PermissionGrantPolicyIdsAssigned -notcontains "ManagePermissionGrantsForSelf.microsoft-user-default-low") {
    Write-Output "The policy ManagePermissionGrantsForSelf.microsoft-user-default-low is NOT present or no policy was returned."
}
