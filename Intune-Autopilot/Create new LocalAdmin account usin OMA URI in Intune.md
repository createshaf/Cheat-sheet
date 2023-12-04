# Create new LocalAdmin account usin OMA URI in Intune
## 1. Devices > Configuration Settings > Create new > Custom
## 2. OMA-URI Settings for Local account as below
1. Name: Local Admin Account
2. OMA-URI
```Powershell
./Device/Vendor/MSFT/Accounts/Users/localadmin/Password
```
3. third
4. Data Type "String"
5. Value "password"


## 3. OMA-URI settings to Add to Local Admin Group
###     3.1 Name: Add to Local Admin Group
    ```Powershell
    ./Device/Vendor/MSFT/Accounts/Users/localadmin/LocalUserGroup
    ```
###     3.2 Data Type "Integer"
###     3.3 Value = "2"