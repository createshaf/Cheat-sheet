# Connect to Microsoft Graph if not already connected
Connect-MgGraph -Scopes "Domain.Read.All"

# Set Variable for Directory Roles
$DirectoryRoles = Get-MgDirectoryRole

# Get privileged role IDs
$PrivilegedRoles = $DirectoryRoles | Where-Object {
    $_.DisplayName -like "*Administrator*" -or $_.DisplayName -eq "Global Reader"
}

# Get the members of these various roles
$RoleMembers = $PrivilegedRoles | ForEach-Object { Get-MgDirectoryRoleMember -DirectoryRoleId $_.Id } |
    Select-Object Id -Unique

# Retrieve details about the members in these roles
$PrivilegedUsers = $RoleMembers | ForEach-Object {
    Get-MgUser -UserId $_.Id -Property UserPrincipalName, DisplayName, Id
}

$Report = [System.Collections.Generic.List[Object]]::new()

foreach ($Admin in $PrivilegedUsers) {
    $License = $null
    $License = (Get-MgUserLicenseDetail -UserId $Admin.id).SkuPartNumber -join ", "
    $Object = [pscustomobject][ordered]@{
        DisplayName           = $Admin.DisplayName
        UserPrincipalName     = $Admin.UserPrincipalName
        License               = $License
    }
    $Report.Add($Object)
}

$Report
