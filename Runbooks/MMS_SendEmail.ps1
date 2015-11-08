workflow MMS_SendEmail
{
    
 ##############################################################################
 # This section contains the input variables that are needed for the runbook
 # to work as expected. Input paramters can be replaced with hardcoded variables
 # within the script if needed. See inspiration below. 
 ##############################################################################

  Write-Output "Starting Script"

 ##############################################################################
 # Hardcoded variables defined within the script. No need to user input.
 ##############################################################################
 
     $AzureOrgIdCredential = "BergEmailRights"
     #$Body = "This is an automated mail send from Azure Automation relaying mail using Office 365."
     $Subject = "Mail send from Azure Automation using Office 365"
	 $From = Get-AutomationVariable -Name 'Office365Email'
 
 	
 
 ##############################################################################
 # Get the PowerShell Credentials from Azure Automation account assets
  Write-Output "Get the PowerShell Credentials from Azure Automation account assets"
 
 ##############################################################################
    
	 
    # Get the PowerShell credential and prints its properties
    $Cred = Get-AutomationPSCredential -Name $AzureOrgIdCredential
	
 	Write-Output "Got Creds"
		
    if ($Cred -eq $null)
    {
        Write-Output "Credential entered: $AzureOrgIdCredential does not exist in the automation service. Please create one `n"   
    }
    else
    {
        $CredUsername = $Cred.UserName
        $CredPassword = $Cred.GetNetworkCredential().Password
        

       Write-Output "Will Email with user: : $CredUsername `n"
    }
##############################################################################
# This section sends a mail using Office 365 secure SMTP services.  
  Write-Output "This section sends a mail using Office 365 secure SMTP services."
##############################################################################
     
     Send-MailMessage `
    -To "leealanberg@gmail.com"  `
    -Subject $Subject  `
    -Body "Someone Pressed the button!" `
    -UseSsl `
    -Port 587 `
    -SmtpServer 'smtp.office365.com' `
    -From $From  `
    -BodyAsHtml `
    -Credential $Cred
  
   Write-Output "Mail is now sent! `n"
      

}
MMS_SendEmail
##############################################################################