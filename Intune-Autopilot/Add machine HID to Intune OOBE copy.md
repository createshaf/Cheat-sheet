# Add machine HID to Intune OOBE
1. Power on the Machine
2. At the Region selection hit Shift+F10
3. On the Command prompt start Powershell
4. run the below 

```Powershell
install-script -name get-windowsautopilotinfo
```
5. Hit Y 3 times. 
6. run the below once completed
```Powershell
set-executionpolicy bypass
```
```Powershell
get-windowsautopilotinfo.ps1 -online

``````