Install-Module Microsoft.Graph -Scope CurrentUser -Force
Import-Module Microsoft.Graph

# Connect to Microsoft Graph
Connect-MgGraph -Scopes "RoleManagement.Read.All", "User.Read.All"

# Get all privileged role assignments
$privilegedRoles = Get-MgRoleManagementDirectoryRoleAssignment | Where-Object { $_.PrincipalId -ne $null }

# Fetch user details and their roles
$privilegedUsers = @()
foreach ($role in $privilegedRoles) {
    $user = Get-MgUser -UserId $role.PrincipalId -Property DisplayName,UserPrincipalName,OnPremisesSyncEnabled | Select-Object DisplayName, UserPrincipalName, OnPremisesSyncEnabled
    $roleDefinition = Get-MgRoleManagementDirectoryRoleDefinition -RoleDefinitionId $role.RoleDefinitionId | Select-Object DisplayName
    
    if ($user.OnPremisesSyncEnabled -eq $true) {
        $privilegedUsers += [PSCustomObject]@{
            DisplayName = $user.DisplayName
            UserPrincipalName = $user.UserPrincipalName
            OnPremisesSyncEnabled = $user.OnPremisesSyncEnabled
            RoleAssigned = $roleDefinition.DisplayName
        }
    }
}

# Export the results to CSV
$privilegedUsers | Export-Csv -Path "PrivilegedUsers_OnPremSync.csv" -NoTypeInformation

Write-Output "Extraction complete. Data saved to PrivilegedUsers_OnPremSync.csv"
