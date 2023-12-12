#  Enable information barriers in SharePoint Online and OneDrive

In this task, we'll enable information barriers in SharePoint Online and OneDrive to promote secure collaboration and prevent unauthorized communication. By following the provided steps, we'll configure and activate information barriers in advance.
1. Open an elevated PowerShell window by selecting the Windows button with the right mouse button and then select Windows PowerShell (Admin).
2. Confirm the User Account Control window with Yes.
3. Run the following cmdlet to install the latest version of the SharePoint Online PowerShell module:

```Powershell
Install-Module -Name Microsoft.Online.SharePoint.PowerShell
```
 4. If prompted to install the PowerShell NuGet provider, enter Y to install the provider.
5. If prompted to install from an untrusted repository, enter Y to install the module from the PSGallery.
6. Run the following cmdlet to connect to the admin center for SharePoint Online:
```Powershell
 Connect-SPOService -Url https://<WWLxZZZZZZ>-admin.sharepoint.com -Credential admin@<WWLxZZZZZZ>.onmicrosoft.com
 ```
7. Login with the MOD Administrator password provided by your lab hosting provider.

8. To enable information barriers in SharePoint and OneDrive, run the following command:

``` Powershell
Set-SPOTenant -InformationBarriersSuspension $false
```
9. Close the PowerShell window once this is complete.