
# $computerName = $args[0]
# $startPort = $args[1]
# $endPort = $args[2]

# for ($item = $startPort; $item -le $endPort; $item++) {
#	
#	$TCPClient = New-Object System.Net.Sockets.TCPClient
#	$AsyncResult = $TCPClient.BeginConnect($computerName, $item, $null, $null)
#	$TCPtimeout = 1 # timeout in milliseconds
#	$Wait = $AsyncResult.AsyncWaitHandle.waitOne($TCPtimeout)
# 	
#	if ($Wait) {
#		$Null = $TCPClient.EndConnect($AsyncResult)
#		if ($TCPClient.Connected) {
#			Write-Host "$item port is open"
#		}
#	}
#}

#Startup="C:\windows\start menu\programs\startup"

$locations = @(
	#"HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders"	
	"HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders"	
)

foreach ($loc in $locations.GetEnumerator()) {
	Write-Host $loc
	$result=(Get-ChildItem $loc)
	Write-Host "Child Item: " $result
	$result=(Get-ItemProperty $loc)
	Write-Host "Item Property: " $result
}




