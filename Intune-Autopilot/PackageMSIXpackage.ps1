##### INSTALL SCRIPT
Add-AppxPackage -path .\1PasswordSetup-latest.msix

#### UNINSTALL SCRIPT
Get-Process -ProcessName ** | Stop-Process -ErrorAction SilentlyContinue - Force
Start-Sleep -Seconds 10
Get-AppxPackage -Name ** | Remove-AppxPackage

# Find the App Name
# 1. Install the App manually on test Machine
Get-AppxPackage | format-table

# 2. Get the package name from search & do below to validate.
Get-AppxPackage <app Name>

# 3. Get the Process name by opening the App & seeing Details tab from Task manager 
# 4. Update & save the script as Uninstall

#### DETECTION SCRIPT
if (Get-AppxPackage -Name "*1Password*") {
	Write-Host "Detected."
	exit 0
} else {
	Write-Host "Not found."
	exit 1
}

#### Add the Install command in Intune
powershell.exe -ExecutionPolicy Bypass -Windowstyle Hidden -File .\install.ps1

#### Add the Uninstall command in Intune
powershell.exe -ExecutionPolicy Bypass -Windowstyle Hidden -File .\uninstall.ps1

#### Add the detection command in Intune
# Use Custom Detetcion script & add the Detection script
