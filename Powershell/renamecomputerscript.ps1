#remove #Domain01\Admin01 and enter the credentials you want to use
Write-Host "Getting serial number of machine, writing to temporary file."
wmic bios get serialnumber >> machine.txt
# powershell command to get the inputted machine's serial number and redirect to a new file called machine.txt
Get-Content machine.txt | Where-Object {$_ -notmatch "serialnumber"} | Set-Content machine2.txt
# read the content of machine.txt exlude serialnumber from appearing, put everything else into machine2.txt
$A = Get-Content(machine2.txt)
#read machine2 and set the contents to $A
Write-Host "Cleaning up files..."
Remove-Item machine.txt
Remove-Item machine2.txt
Rename-Computer -NewName "CSC-$A" -DomainCredential #Domain01\Admin01 -Restart
#perform the intended function, make sure to remove the # and set the domain and admin name before using
Write-Host "Done."