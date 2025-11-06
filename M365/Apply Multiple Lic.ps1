# Excel File Setup:
# Save as CSV format
# UserPrincipalName
# john.doe@company.com
# jane.smith@company.com


# Step 1: Install and Import the Microsoft Graph Module
Install-Module Microsoft.Graph -Scope CurrentUser
Import-Module Microsoft.Graph

# Step 2: Connect to Microsoft Graph
Connect-MgGraph -Scopes "User.ReadWrite.All","Directory.ReadWrite.All"

# Step 3: Find Your Business Premium License SKU
# Run this to list all available SKUs in your tenant:
Get-MgSubscribedSku | Select-Object SkuId, SkuPartNumber

# Step 4: Import Users from CSV
$users = Import-Csv "C:\Licenses\AssignLicenses.csv"

# Step 5: Assign the License
# Replace <SkuId> below with your actual ID from Step 3.

$sku = "<SkuId>"

foreach ($user in $users) {
    try {
        Write-Host "Assigning license to $($user.UserPrincipalName)..."
        Set-MgUserLicense -UserId $user.UserPrincipalName -AddLicenses @{SkuId=$sku} -RemoveLicenses @()
        Write-Host "✅ License assigned to $($user.UserPrincipalName)"
    } catch {
        Write-Host "❌ Failed to assign license to $($user.UserPrincipalName): $($_.Exception.Message)"
    }
}

# You can check license status for a specific user:
Get-MgUserLicenseDetail -UserId "john.doe@company.com" | Select-Object SkuPartNumber


# ⚙️ Optional: Remove Existing Licenses (if needed)
# If you want to clean up old licenses before applying new ones:
$currentLicenses = (Get-MgUserLicenseDetail -UserId $user.UserPrincipalName).SkuId
Set-MgUserLicense -UserId $user.UserPrincipalName -AddLicenses @{SkuId=$sku} -RemoveLicenses $currentLicenses

