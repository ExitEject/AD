Write-Host "This is the automatic enabling and disabling scheduling tool for Active Directory.
Before using this tool, please ensure the following:
1. Import-Module ActiveDirectory is installed
2. You are running as admin
3. Set-ExecutionPolicy RemoteSigned has been enabled
4. For file location try C:\ if you do not know " -ForegroundColor Green
$filepath = Read-Host "Enter location of where you want the scheduled tasks saved" 
$test = Test-Path -Path $filepath 
if ($test -ne $filepath) {
Write-Host "File path does not exist, verify path exist."-ForegroundColor Red
exit
}
$user = Read-Host "Enter name of User" -ForegroundColor Green
#$user is what person's AD account you want disabled or enabled. needs to be like jdoe, whatever the actual AD username is before domain#
Get-ADUser $user -ErrorAction -Stop
#ad module finds the user and spits out the data letting you know it was valid#
$option = Read-Host "Enter reason of scheduling:
[1] Onboarding
[2] Offboarding
[3] Vacation" -ForegroundColor Green
while ($option -notin
'1', '2', '3') {
    $option = Read-Host "Error, please type a number 1 OR 2 OR 3"
} 

#this will lead to only some of the questions being asked offboard(disable), vacation (normal) 
#onboarding (disable in 1 hr, and only asks what date they want to be onboarded)
if ($option = '1') {
    $time1 = Get-Date
    $time1.ToString("YYYY-MM-DD HH:MM:SS")
    $startvacation = ($time1).AddHours(1)
    $stopvacation = Read-Host "Enter date you want the Users account to be *enabled* (no /) YYYY-MM-DD HH:MM:SS"
}
elseif ($option = '3') {
    $startvacation = Read-Host "Enter date you want the Users account to be *disabled* (no /) YYYY-MM-DD HH:MM:SS" 
    $stopvacation = Read-Host "Enter date you want the Users account to be *enabled* (no /) YYYY-MM-DD HH:MM:SS" 

}
elseif ($option = '2') {
    $time2 = Get-Date
    $time2.ToString("YYYY-MM-DD HH:MM:SS")
    $stopvacation = ($time2).AddMinutes(5)
    $startvacation = Read-Host "Enter date you want the Users account to be *disabled* (no /) YYYY-MM-DD HH:MM:SS" 
}
#these functions could be done more efficient to prevent DRY
Remove-JobTrigger -Name "$startvacation" -ErrorAction SilentlyContinue
Remove-JobTrigger -Name "$stopvacation" -ErrorAction SilentlyContinue
#both of the above functions are kinda pointless and may create visible error messages its just to clean up any previous dupes*
$startjobnew = New-JobTrigger -Once -At $startvacation 
$stopjobnew = New-JobTrigger  -Once -At $stopvacation 
#this creates the triggers for the scheduled tasks to start*
$startjobnew1 = New-ScheduledJobOption -RunElevated -WakeToRun -RequireNetwork:$true
$stopjobnew1 = New-ScheduledJobOption  -RunElevated -WakeToRun -RequireNetwork:$true
#these create the new joboptions to run ps as admin and wake the computer, it also makes the job require network to function#
UnRegister-ScheduledJob -Name Start$user -ErrorAction SilentlyContinue
UnRegister-ScheduledJob -Name Stop$user -ErrorAction SilentlyContinue
#both of the above functions are kinda pointless and may create visible error messages its just to clean up any previous dupes*
Add-Content -Path $filepath\start$user.ps1 -Value "Disable-ADAccount -Identity $User
Remove-Item -Path $filepath\start$user.ps1"
#this is where it creates the disable account powershell script#
Add-Content -Path $filepath\stop$user.ps1 -Value "Enable-ADAccount -Identity $User
Remove-Item -Path $filepath\stop$user.ps1"
#this is where it creates the enable account powershell script#
Register-ScheduledJob -Name Start$user -FilePath $filepath\start$user.ps1 -Trigger $startjobnew -ScheduledJobOption $startjobnew1
Register-ScheduledJob -Name Stop$user -FilePath $filepath\stop$user.ps1 -Trigger $stopjobnew -ScheduledJobOption $stopjobnew1
Write-Host "Tasks Scheduled Succesfully."-ForegroundColor Green
#this creates the scheduled job and assigns the trigger to previously made scripts, the files will delete themselves after they trigger too.*
#this script relies on the Import-Module ActiveDirectory being installed#
#to "cancel" purposed scheduled tasks simply delete the start/stop$user.ps1 files wherever they are stored. The scheduled task doesn't have to be cancelled if these are deleted because they won't do anything#
#you could also cancel all scheduled jobs or that job in powershell but IMO its much easier to just delete the ps1s#
#ideas BATCH jobs for large onboardings (more than 2), cancel tool, maybe even a script to add the user and schedule at the same time??#
#graphical interface like folder select, calender select
#package as a module, or .exe?
#vetted and tested on VM network of AD environment, not tested by PSRemote
#created by ExitEject 11/11/2023
