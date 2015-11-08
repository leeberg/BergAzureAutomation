#
#
#

$LabMachines = "Nano-01","Nano-02","Nano-03","Nano-04"
	
ForEach($Server in $LabMachines)
{
	get-vm $Server -ErrorAction SilentlyContinue | stop-vm -TurnOff -Force -Passthru	
}


#
#
#