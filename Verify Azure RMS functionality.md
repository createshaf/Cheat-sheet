# Verify Azure RMS functionality

1. Open an elevated PowerShell window by selecting the Windows button with the right mouse button and then select Windows PowerShell (admin).

2. Confirm the User Account Control window with Yes.

3. Enter the following cmdlet to install the latest Exchange Online PowerShell module version:

```` Powershell
Install-Module ExchangeOnlineManagement
````
4. Confirm the NuGet provider security dialog with Y for Yes and press Enter. This process may take some time to complete.

5. Confirm the Untrusted repository security dialog with Y for Yes and press Enter. This process may take some time to complete.

6. Enter the following cmdlet to change your execution policy and press Enter

```` Powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
````
7. Confirm the Execution Policy Change with Y for Yes and press Enter.

8. Close the PowerShell window.

9. Open a regular PowerShell window, by selecting the Windows button with the right mouse button and select Windows PowerShell.

10. Enter the following cmdlet to use the Exchange Online PowerShell module and connect to your tenant:

```` Powershell
Connect-ExchangeOnline
````

11. When the Sign in window is displayed, sign in as sign in as JoniS@WWLxZZZZZZ.onmicrosoft.com (where ZZZZZZ is your unique tenant ID provided by your lab hosting provider). You will use the password you reset Joni's to in a previous lab.

12. Verify Azure RMS and IRM is activated in your tenant by using the following cmdlet and press Enter:

```` PowerShell
Get-IRMConfiguration | fl AzureRMSLicensingEnabled
````

13. Test the Azure RMS templates used for Office 365 Message Encryption against the other pilot user Megan Bowen by using the following cmdlet and press Enter:

```` Powershell
Test-IRMConfiguration -Sender MeganB@contoso.com -Recipient MeganB@contoso.com
````

14. Verify all tests are in the status PASS and no errors are shown.

15. Leave the PowerShell window open.