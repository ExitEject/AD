#remove #Domain01\Admin01 and enter the credentials you want to use
Write-Host "Getting serial number of machine, writing to temporary file."
wmic bios get serialnumber >> machine.txt
# PowerShell
Get-Content machine.txt | Where-Object {$_ -notmatch "serialnumber"} | Set-Content machine2.txt
$A = Get-Content(machine2.txt)
Write-Host "Cleaning up files..."
Remove-Item machine.txt
Remove-Item machine2.txt
Rename-Computer -NewName "CSC-$A" -DomainCredential #put Domain01\Admin01 -Restart
Write-Host "Done."