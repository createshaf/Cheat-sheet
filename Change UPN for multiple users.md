# Change UPN for multiple users
```Powershell
Import-Module ActiveDirectory
$oldSuffix = "morani.local"
$newSuffix = "M365B651303.onmicrosoft.com"
$ou = "OU=Users,OU=CloudSync,OU=morani.local,DC=morani,DC=local"
$server = "DC01"
Get-ADUser -SearchBase $ou -filter * | ForEach-Object {
$newUpn = $_.UserPrincipalName.Replace($oldSuffix,$newSuffix)
$_ | Set-ADUser -server $server -UserPrincipalName $newUpn
}
```
