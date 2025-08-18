Connect-MgGraph
#Get Product list - create lookup between GUIDs and somewhat-human-readable strings
$SkuHashTable = @{}
ForEach ($Sku in Get-MgSubscribedSku) { $SkuHashTable.Add($Sku.SkuId, $Sku.SkuPartNumber) }

#Get Licensed Users
$users = Get-MgUser -Filter 'assignedLicenses/$count ne 0' -All -ConsistencyLevel eventual -CountVariable licensedUserCount -Property Id, DisplayName, UserPrincipalName, AccountEnabled, licenseAssignmentStates

#Add columns of group based vs direct assigned licenses
$users = $users | Select-Object Id, DisplayName, UserPrincipalName, licenseAssignmentStates, @{N = "DirectAssignment"; E = { ($_.licenseAssignmentStates | Where-Object AssignedByGroup -eq $null).SkuId } }, @{N = "GroupBasedAssignment"; E = { ($_.licenseAssignmentStates | Where-Object AssignedByGroup -ne $null).SkuId } }

#Convert those to more human readable
$users = $users | Select-Object Id, DisplayName, UserPrincipalName, @{N="licenseSkus";E={$_.LicenseAssignmentStates.SkuId}}, @{N = "AllSkus"; E = { $SkuHashTable[$_.licenseAssignmentStates.SkuId] } }, @{N = "DirectSkus"; E = { $SkuHashTable[$_.DirectAssignment] } }, @{N = "GroupBasedSkus"; E = { $SkuHashTable[$_.GroupBasedAssignment] } }

#List any users with E3 directly assigned
$users | ? DirectSkus -contains "AAD_PREMIUM"

#Product names and service plan identifiers for licensing - Use the below link to find the lic. name
https://learn.microsoft.com/en-us/entra/identity/users/licensing-service-plan-reference
