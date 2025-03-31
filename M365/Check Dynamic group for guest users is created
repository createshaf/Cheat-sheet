# Ensure you have the Microsoft Graph PowerShell module installed
# Install-Module Microsoft.Graph -Scope CurrentUser

# Connect to Microsoft Graph if not already connected
Connect-MgGraph -Scopes "Group.Read.All"

# Retrieve only Dynamic Groups
$dynamicGroups = Get-MgGroup -Filter "groupTypes/any(g:g eq 'DynamicMembership')" -All

# Display results with rule syntax
$dynamicGroups | Select-Object DisplayName, Id, GroupTypes, @{Name="MembershipRule"; Expression={$_.MembershipRule}}
