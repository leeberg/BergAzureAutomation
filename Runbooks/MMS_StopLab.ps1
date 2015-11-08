#
#
#
New-EventLog -Logname System -Source OMSAutomation

Write-EventLog -EventId 1 -LogName System -Message "Runbook MMS_StopLab Started" -Source OMSAutomation

$LabMachines = "Nano-01","Nano-02","Nano-03","Nano-04"
	
ForEach($Server in $LabMachines)
{
	get-vm $Server -ErrorAction SilentlyContinue | stop-vm -TurnOff -Force -Passthru	
	
	Write-EventLog -EventId 2 -LogName System -Message "Runbook MMS_StopLab Stopped Server $Server" -Source OMSAutomation
	
	
}


Write-EventLog -EventId 3 -LogName System -Message "Runbook MMS_StopLab Complete" -Source OMSAutomation


#
#
#