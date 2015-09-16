workflow Get-Information
{
	
	  param (
            
        [Parameter(Mandatory=$false)]
        [string]
        $Company="Contoso"
		
	  )


	$InformationType += Get-Date
	 
	 
	 
	 
	 
	 [OutputType([string])]
	 $output = $InformationType
	 
	 Write-Output "Get-Information Complete"
	 Write-OUtput "InfoType is: $InformationType"
	 Write-Output "Output is: $output"
	 
	 Write-Output $output
	 
	 
	 
}