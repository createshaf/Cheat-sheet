# Export All AD Users to CSV
```Powershell
Get-ADUser -Filter * -SearchBase "OU=Users,OU=CloudSync,OU=morani.local,DC=morani,   DC=local" -Properties * | Select-Object name, userprincipalname | export-csv -path "c:\temp\userexport-after.csv"
```
# Display AD Users
```Powershell
Get-ADUSER -Filter * -SearchBase "OU=Users,OU=CloudSync,OU=morani.local,DC=morani,DC=local" | fl name, userprincipalname
```
