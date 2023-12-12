# Task 4 : Create custom branding template


Protected messages sent by your organizations finance department require special branding, including customized introduction and body texts and a Disclaimer link in the footer. The finance messages shall also expire after seven days. In this task, you will create a new custom OME configuration and create a transport rule to apply the OME configuration to all mail sent from the finance department.


1. Run the following cmdlet to create a new configuration:

```` Powershell
New-OMEConfiguration -Identity "Finance Department" -ExternalMailExpiryInDays 7
````

2. Confirm the warning message for customizing the template with "Y" for Yes and press Enter.

3. Change the introduction text message with the following cmdlet:

```` Powershell
Set-OMEConfiguration -Identity "Finance Department" -IntroductionText " from Contoso Ltd. finance department has sent you a secure message."
````
4. Confirm the warning message for customizing the template with "Y" for Yes and press Enter.

5. Change the body email text of the message with the following cmdlet:

```` Powershell
Set-OMEConfiguration -Identity "Finance Department" -EmailText "Encrypted message sent from Contoso Ltd. finance department. Handle the content responsibly."
````

6. Confirm the warning message for customizing the template with "Y" for Yes and press Enter.

7. Change the disclaimer URL to point to Contoso's privacy statement site:

```` Powershell
Set-OMEConfiguration -Identity "Finance Department" -PrivacyStatementURL "`https://contoso.com/privacystatement.html`"
````

8. Confirm the warning message for customizing the template with "Y" for Yes and press Enter..

9. Use the following cmdlet to create a mail flow rule, which applies the custom OME template to all messages sent from the finance team. This process may take a few seconds to complete

```` Powershell
New-TransportRule -Name "Encrypt all mails from Finance team" -FromScope InOrganization -FromMemberOf "Finance Team" -ApplyRightsProtectionCustomizationTemplate "Finance Department" -ApplyRightsProtectionTemplate Encrypt
````

10. Type the following cmdlet to verify changes.

```` Powershell
Get-OMEConfiguration -Identity "Finance Department" | Format-List
````
11. Leave the PowerShell open. You have successfully created a new transport rule that applies the custom branding template automatically, when a member of the finance department sends a message to external recipients.