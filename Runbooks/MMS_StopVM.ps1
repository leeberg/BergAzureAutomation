
param(
	 [Parameter(Mandatory=$true)]
     [string] 
     $VMName	
)  

Try
{
	get-vm $VMName -ErrorAction SilentlyContinue | stop-vm -TurnOff -Force -Passthru	
}

Catch
{
	Write-Output "Failed to Stop: $VMName"
}