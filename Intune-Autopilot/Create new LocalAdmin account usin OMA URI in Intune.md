# Create new LocalAdmin account usin OMA URI in Intune
## Devices > Configuration Settings > Create new > Custom
## OMA-URI Settings for Local account as below
1. Name: Local Admin Account
2. OMA-URI
```Powershell
./Device/Vendor/MSFT/Accounts/Users/localadmin/Password
```
3. third
4. Data Type "String"
5. Value "password"


## OMA-URI settings to Add to Local Admin Group
1. Name: Add to Local Admin Group
2. OMA-URI
```Powershell
./Device/Vendor/MSFT/Accounts/Users/localadmin/LocalUserGroup
```
3. Data Type "Integer"
4. Value = "2"