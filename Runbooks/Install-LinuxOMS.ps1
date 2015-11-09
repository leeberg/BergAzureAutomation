Param(
  [string]$TargetServer

)


New-EventLog -Logname System -Source OMSAutomation

Write-EventLog -EventId 1 -LogName System -Message "Runbook Install Linux OS Started for $TargetServer" -Source OMSAutomation

Write-EventLog -EventId 2 -LogName System -Message "Imporintg POSH-SSH Module for $TargetServer" -Source OMSAutomation

#Import Module - Runbooks Folder on Hybrid Worker
Import-Module 'C:\Runbooks\Posh-SSH\Posh-SSH.psd1' -Force

#Get Various Cred / OMS Variables
Write-EventLog -EventId 3 -LogName System -Message "Getting Various Cred / OMS Variables for $TargetServer" -Source OMSAutomation

$cred = Get-AutomationPSCredential -Name 'BergLabLinuxAdmin'
$TargetServerIP = $TargetServer
$WorkspaceID = Get-AutomationVariable -Name 'OMSWorkspaceID'
$PrimaryKey = Get-AutomationVariable -Name 'OMSPrimaryKey'

Write-Output "Performing install on $TargetServer"
	
#Initiate SSH Session
Write-EventLog -EventId 4 -LogName System -Message "Initiating SSH Session for $TargetServer" -Source OMSAutomation

$Out = New-SSHSession -ComputerName $TargetServerIP -Credential (Get-Credential $cred) -AcceptKey
#Save Sesssion ID
$Out = $Session = Get-SSHSession 



Write-Output "Starting Copy and Install"
Write-EventLog -EventId 5 -LogName System -Message "Starting Copy and Install for $TargetServer" -Source OMSAutomation
	
Write-Output "COPYING INSTALLER"
Write-EventLog -EventId 6 -LogName System -Message "Copying OMS Universal Linux installer for $TargetServer" -Source OMSAutomation
$Out = Set-SCPFile -LocalFile 'C:\Runbooks\OMSInstall\omsagent-1.0.0-47.universal.x64.sh'  -RemotePath "/tmp/" -ComputerName $TargetServerIP -Credential (Get-Credential $cred) 
	
WRITE-OUTPUT "INSTALL"
Write-EventLog -EventId 7 -LogName System -Message "Running OMS Universal Linux installer for $TargetServer" -Source OMSAutomation
$Out = Invoke-SSHCommand -Index $Session.SessionID -Command "chmod +x /tmp/omsagent-1.0.0-47.universal.x64.sh"
$Out = Invoke-SSHCommand -Index $Session.SessionID -Command "md5sum /tmp/omsagent-1.0.0-47.universal.x64.sh"
$Out = Invoke-SSHCommand -Index $Session.SessionID -Command "Sudo /tmp/omsagent-1.0.0-47.universal.x64.sh --install -w 12b0fc66-f4bc-450b-8164-4976a1de27f5 -s 71+Ee1gIvboTVEgAF+52SlnZRIL8l8h9yoU25GeAuyb03KZB+ZgC7UPuhEhKoUd85j4Y23GT9Wz3uYAmJz74Xg=="

WRITE-OUTPUT "Complete"
Write-EventLog -EventId 8 -LogName System -Message "Completed OMS Universal Linux installer for $TargetServer" -Source OMSAutomation

WRITE-OUTPUT "Close SSH Session"
$OUT = Remove-SSHSession -Index $Session.SessionID
Write-EventLog -EventId 9 -LogName System -Message "Closed Session - Runbooks Complete for $TargetServer" -Source OMSAutomation

