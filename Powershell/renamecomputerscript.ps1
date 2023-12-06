#remove #Domain01\Admin01 and enter the credentials you want to use
wmic bios get serialnumber >> machine.txt
Get-Content machine.txt-replace 'serialnumber'
$A = Get-Content(machine.txt)
Get-Content(machine.txt)
#Rename-Computer -NewName "CSC-$A" -DomainCredential #put Domain01\Admin01 -Restart
#Remove-Item machine.txt
#Write-Host "Done."ls