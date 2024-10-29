#  Enable information barriers in SharePoint Online and OneDrive
This article will show you how to use PowerShell to generate a usage report of all your OneDrive sites in Office 365.


```` Powershell
Connect-SPOService -Url https://skrubbeltrang-admin.sharepoint.com
Write-Host "Getting OneDrive sites..."
$OneDrives = Get-SPOSite -IncludePersonalSite $True -Limit All -Filter "Url -like '-my.sharepoint.com/personal/'"
$Result = @()
ForEach ($OneDrive in $OneDrives) {
    $OneDrive = [PSCustomObject]@{
        Email       = $OneDrive.Owner
        URL         = $OneDrive.URL
        QuotaGB     = [Math]::Round($OneDrive.StorageQuota / 1024, 3) 
        UsedGB      = [Math]::Round($OneDrive.StorageUsageCurrent / 1024, 3)
        PercentUsed = [Math]::Round(($OneDrive.StorageUsageCurrent / $OneDrive.StorageQuota * 100), 3)
    }
    $Result += $OneDrive
}
$Result | ft Email,URL,UsedGB,QuotaGB,PercentUsed -AutoSize
````

To Export the same report run the below 
```` Powershell
$Result | Export-Csv c:\Temp\OneDriveStats.csv -NoTypeInformation
````