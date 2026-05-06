# Define the inactivity threshold (e.g., 90 days)
$InactiveDays = 90
$CutoffDate = (Get-Date).AddDays(-$InactiveDays)

# Retrieve all devices with relevant properties
$AllDevices = Get-MgDevice -All -Property "Id","DisplayName","ApproximateLastSignInDateTime","OperatingSystem","AccountEnabled"

# Filter for stale devices
$StaleDevices = $AllDevices | Where-Object { 
    $_.ApproximateLastSignInDateTime -le $CutoffDate -and $_.ApproximateLastSignInDateTime -ne $null 
}

# Display results
$StaleDevices | Select-Object DisplayName, ApproximateLastSignInDateTime, OperatingSystem | Format-Table
