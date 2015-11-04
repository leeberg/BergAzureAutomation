<#
.SYNOPSIS
    Sending email from Azure Automation using Office 365 (Secure SMTP)

.DESCRIPTION
   This Runbook sample demonstrates how Azure Automation can be used to send emails using a secure SMTP
   service like Office 365. 
   
   This Runbook use global assets defined in the Azure Automation Account. 
   For more information about how to create assets please check our this article:
   http://azure.microsoft.com/blog/2014/07/29/getting-started-with-azure-automation-automation-assets-2/
   
   WARNING: For this runbook to work, you must have created the 
   following Assets: Powershell Credentials for the email account. 

.PARAMETER AzureOrgIdCredential
     String name of the PSCredential stored in global assets for authentication against the
     Secure SMTP Service

.PARAMETER Body
    String that contains the body of the email that are send to the users
                 
.PARAMETER To
    String name of the PSCredential stored in global assets 

.PARAMETER From
    String name of the certificate uploaded to global assets

.NOTES
	Author: Peter Selch Dahl from ProActive A/S
	Last Updated: 12/21/2014
    Version 1.1   
#>

workflow SendMailUsingOffice365
{
    
 ##############################################################################
 # This section contains the input variables that are needed for the runbook
 # to work as expected. Input paramters can be replaced with hardcoded variables
 # within the script if needed. See inspiration below. 
 ##############################################################################
 
      Param
    (            
       # [parameter(Mandatory=$true)]
       # [String]
       # $Subject,

        [parameter(Mandatory=$true)]
        [String] $Body,
                        
        [parameter(Mandatory=$true)]
        [String] $To

    )
    
 ##############################################################################
 # Hardcoded variables defined within the script. No need to user input.
 ##############################################################################
 
     $AzureOrgIdCredential = "BergEmailRights"
     #$Body = "This is an automated mail send from Azure Automation relaying mail using Office 365."
     $Subject = "Mail send from Azure Automation using Office 365"
	 $From = Get-AutomationVariable -Name 'Office365Email'
 
 ##############################################################################
 # Get the PowerShell Credentials from Azure Automation account assets
 ##############################################################################
     
    # Get the PowerShell credential and prints its properties
    $Cred = Get-AutomationPSCredential -Name $AzureOrgIdCredential

		
    if ($Cred -eq $null)
    {
        Write-Output "Credential entered: $AzureOrgIdCredential does not exist in the automation service. Please create one `n"   
    }
    else
    {
        $CredUsername = $Cred.UserName
        $CredPassword = $Cred.GetNetworkCredential().Password
        

       # Write-Output "Password: $CredPassword `n"
    }
##############################################################################
# This section sends a mail using Office 365 secure SMTP services.  
##############################################################################
     
     Send-MailMessage `
    -To $To  `
    -Subject $Subject  `
    -Body $Body `
    -UseSsl `
    -Port 587 `
    -SmtpServer 'smtp.office365.com' `
    -From $From  `
    -BodyAsHtml `
    -Credential $Cred
  
        Write-Output "Mail is now sent! `n"
      

}

##############################################################################