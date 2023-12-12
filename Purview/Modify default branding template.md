# Modify default branding template

There is a requirement in your organization to restrict trust for foreign identity providers, such as Google or Facebook. Because these social IDs are activated by default for accessing messages protected with message encryption, you need to deactivate the use of social IDs for all users in your organization.


1. Run the following cmdlet to view the default configuration:

```` Powershell
Get-OMEConfiguration -Identity "OME Configuration" | fl
````

2. Review the settings and confirm that the SocialIdSignIn parameter is set to True.

3. Run the following cmdlet to restrict the use of social IDs for accessing messages from your tenant protected with OME:

```` Powershell
Set-OMEConfiguration -Identity "OME Configuration" -SocialIdSignIn:$false
````

4. Confirm the warning message for customizing the default template with "Y" for Yes and press Enter.

5. Check the default configuration again and validate, the SocialIdSignIn parameter is now set to False.

```` Powershell
Get-OMEConfiguration -Identity "OME Configuration" | fl
````

6. Notice the result should show the SocialIDSignIn is set to False. Leave the PowerShell window and client open.
You have successfully deactivated the usage of foreign identity providers, such as Google and Facebook in Office 365 Message Encryption.