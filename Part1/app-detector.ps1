

$startupLocations = New-Object System.Collections.Generic.List[System.Object]
$startupApps = New-Object System.Collections.Generic.List[System.Object]
$logfile = "report.log"

$locations = @(	
	"HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders"
	"HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders"
	"HKLM:\Software\Microsoft\Windows\CurrentVersion\explorer\Shell Folders"
	"HKLM:\Software\Microsoft\Windows\CurrentVersion\explorer\User Shell Folders"
)

# Collect all startup directories
foreach ($key in $locations.GetEnumerator()) {
	$startup=(Get-ItemProperty $key).Startup
	$startupLocations.Add($startup)
}
[array]$startupLocations = $startupLocations | Sort-Object -Unique

# Collect all items in the startup directories
foreach ($dir in $startupLocations.GetEnumerator()) {
	foreach ($item in Get-ChildItem $dir) {
		$startupApps.Add($item) | out-null
	}
}

# Read the file of known startup applications (using a hashset)
$knownApps = Get-Content -Path .\recorded-apps
if ($knownApps -eq $null) { 
	$knownApps = New-Object System.Collections.Generic.HashSet[String]
} else {
	[System.Collections.Generic.HashSet[String]]$knownApps = $knownApps
}

# Startup Detection
foreach ($item in $startupApps) {	
	if ( ! $knownApps.Contains($item)) {
		$timestamp = Get-Date
		$out = [string]$timestamp + " Unknown Application In Startup: '" + [string]$item + "'"
		$out | Tee-Object -Append -FilePath $logfile
		$knownApps.Add($item) | out-null
	}
}

# Write back to file
$knownApps | Set-Content -Path recorded-apps

