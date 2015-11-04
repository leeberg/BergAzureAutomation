Param(
  [string]$TargetServer,
  [string]$InstallType
)


### TODO ###
# Download OMS Config file 
# Store on hybrid $TargetServer
# Transfer to Linux Box
# Restart Service

#Import Module - Runbooks Folder on Hybrid Worker
Import-Module 'C:\Runbooks\Posh-SSH\Posh-SSH.psd1' -Force

#Get Various Cred / OMS Variables
$cred = Get-AutomationPSCredential -Name 'BergLabLinuxAdmin'
$TargetServerIP = $TargetServer
$WorkspaceID = Get-AutomationVariable -Name 'OMSWorkspaceID'
$PrimaryKey = Get-AutomationVariable -Name 'OMSPrimaryKey'

Write-Output "Performing $InstallType install on $TargetServer"
	
#Initiate SSH Session
$Out = New-SSHSession -ComputerName $TargetServerIP -Credential (Get-Credential $cred) -AcceptKey
#Save Sesssion ID
$Out = $Session = Get-SSHSession 

### TODO ###
# Download Latest and greatest OMS AGENT from the web???
# Store on hybrid $TargetServer

Write-Output "Starting Copy and Install"
IF($InstallType -eq 'RPM')
{
	Write-Output "RPM INSTALLER"
	Write-Output "Copy OMS RPM Installers from RUnbooks Directory"
	$Out = Set-SCPFile -LocalFile 'C:\Runbooks\OMSInstall\rpm\omi-1.0.8-2.universalr.1.x64.rpm'  -RemotePath "/tmp/" -ComputerName $TargetServerIP -Credential (Get-Credential $cred) 
	$Out = Set-SCPFile -LocalFile 'C:\Runbooks\OMSInstall\rpm\scx-cimprov-1.6.1-104.universal.x64.rpm' -RemotePath "/tmp/" -ComputerName $TargetServerIP -Credential (Get-Credential $cred) 
	$Out = Set-SCPFile -LocalFile 'C:\Runbooks\OMSInstall\rpm\omsagent-1.0.0-11.universal.x64.rpm' -RemotePath "/tmp/" -ComputerName $TargetServerIP -Credential (Get-Credential $cred)
	
	WRITE-OUTPUT "RPM INSTALL"
	$Out = Invoke-SSHCommand -Index $Session.SessionID -Command "sudo rpm -Uvh /tmp/omi-1.0.8-2.universalr.1.x64.rpm"
	$Out = Invoke-SSHCommand -Index $Session.SessionID -Command "sudo rpm -Uvh /tmp/scx-cimprov-1.6.1-104.universal.x64.rpm"
	$Out = Invoke-SSHCommand -Index $Session.SessionID -Command "sudo rpm -Uvh /tmp/omsagent-1.0.0-11.universal.x64.rpm" 
}

IF($InstallType -eq 'DEB')
{
	Write-Output "DEB INSTALLER"
	Write-Output "Copy OMS DEB Installers from RUnbooks Directory"
	$Out = Set-SCPFile -LocalFile 'C:\Runbooks\OMSInstall\deb\omi-1.0.8-2.universald.1.x64.deb'  -RemotePath "/tmp/" -ComputerName $TargetServerIP -Credential (Get-Credential $cred) 
	$Out = Set-SCPFile -LocalFile 'C:\Runbooks\OMSInstall\deb\scx-cimprov-1.6.1-104.universal.x64.deb' -RemotePath "/tmp/" -ComputerName $TargetServerIP -Credential (Get-Credential $cred) 
	$Out = Set-SCPFile -LocalFile 'C:\Runbooks\OMSInstall\deb\omsagent-1.0.0-11.universal.x64.deb' -RemotePath "/tmp/" -ComputerName $TargetServerIP -Credential (Get-Credential $cred)
	
	WRITE-OUTPUT "DEB INSTALL"
	$Out = Invoke-SSHCommand -Index $Session.SessionID -Command "sudo dpkg –i  /tmp/omi-1.0.8-2.universald.1.x64.deb"
	$Out = Invoke-SSHCommand -Index $Session.SessionID -Command "sudo dpkg –i  /tmp/scx-cimprov-1.6.1-104.universal.x64.deb"
	$Out = Invoke-SSHCommand -Index $Session.SessionID -Command "sudo dpkg –i  /tmp/omsagent-1.0.0-11.universal.x64.deb" 
}


WRITE-OUTPUT "Run OMS setup script"
$Out = Invoke-SSHCommand -Index $Session.SessionID -Command "sudo /opt/microsoft/omsagent/bin/omsadmin.sh -w $WorkspaceID -s $PrimaryKey"

#Restart Syslog Service
$Out = Invoke-SSHCommand -Index $Session.SessionID -Command "sudo dpkg –i  /tmp/omsagent-1.0.0-11.universal.x64.deb" 


WRITE-OUTPUT "Close SSH Session"
$OUT = Remove-SSHSession -Index $Session.SessionID
