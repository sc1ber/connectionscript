# get input from file input.txt
$t = Get-Content input.txt
# check if output.txt exists, delete if yes
If (Test-Path -Path output.txt -PathType Leaf) {
	Remove-Item output.txt
}
# get date
Get-Date | Out-File output.txt -Append -Encoding UTF8
# initialize default variables
$state = " "
$port = "32"
$t | ForEach-Object {
	# check if text is a comment
	If ($PSItem.Contains("//")){
		$state = " "
		If ($PSItem.Contains("Port")){
		    $port = $PSItem.Substring($PSItem.LastIndexOf('=') + 1)
		}
		"$PSItem"| Out-File output.txt -Append -Encoding UTF8
		Write-Host "$PSItem"
	}
	Else {
		#check if there is an instance
		If ($PSItem.Contains(" ")){
			$pos = $PSItem.LastIndexOf(" ")
			$address = $PSItem.Substring(0, $pos)
			$instance = $PSItem.Substring($pos+1)
			$full = $port+$instance
		}
		Else{
			$address = $PSItem
			$full = $port
		}
		# check connection using port
		If ((Test-NetConnection -ComputerName $address -Port $full -ErrorAction SilentlyContinue -WarningAction SilentlyContinue).TcpTestSucceeded) { 
			$state = "- UP"
		}
		Else {
			$state = "- DOWN"
		}
		"$address $full $state"| Out-File output.txt -Append -Encoding UTF8
		Write-Host "$address $full $state"
	}
}
Write-Host "Output saved in output.txt"
pause