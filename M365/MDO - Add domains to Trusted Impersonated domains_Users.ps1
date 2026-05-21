## For Domains

$PolicyName = "Migrated from Checkpoint — Anti-Phishing"
$CsvPath    = "C:\Temp\trusted_domains.csv"

$domains  = (Import-Csv $CsvPath).Domain
$existing = (Get-AntiPhishPolicy -Identity $PolicyName).ExcludedDomains
$merged   = ($existing + $domains) | Sort-Object -Unique

Set-AntiPhishPolicy -Identity $PolicyName -ExcludedDomains $merged

Write-Host "✅ Added $($domains.Count) domains to $PolicyName" -ForegroundColor Green
Write-Host "Total trusted domains now: $($merged.Count)"


## For Users
$PolicyName = "Migrated from Checkpoint — Anti-Phishing"
$CsvPath    = "C:\Temp\trusted_senders.csv"

$senders  = (Import-Csv $CsvPath).Sender
$existing = (Get-AntiPhishPolicy -Identity $PolicyName).ExcludedSenders
$merged   = ($existing + $senders) | Sort-Object -Unique

Set-AntiPhishPolicy -Identity $PolicyName -ExcludedSenders $merged

Write-Host "✅ Added $($senders.Count) senders to $PolicyName" -ForegroundColor Green
Write-Host "Total trusted senders now: $($merged.Count)"
