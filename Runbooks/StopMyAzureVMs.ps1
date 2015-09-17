<#

.NOTES
	Author: Peter Selch Dahl
	Last Updated: 4/14/2014  
#>

workflow StopMyAzureVMs
{   
      param(   )


       $MyConnection = "My MSDN Azure Account Connection"
       $MyCert = "MSDN Azure Certifcate"

  
    # Get the Azure Automation Connection

    $Con = Get-AutomationConnection -Name $MyConnection
    if ($Con -eq $null)
    {
        Write-Output "Connection entered: $MyConnection does not exist in the automation service. Please create one `n"   
    }
    else
    {
        $SubscriptionID = $Con.SubscriptionID
        $ManagementCertificate = $Con.AutomationCertificateName
       
   #     Write-Output "-------------------------------------------------------------------------"
   #     Write-Output "Connection Properties: "
   #     Write-Output "SubscriptionID: $SubscriptionID"
    #    Write-Output "Certificate setting name: $ManagementCertificate `n"
    }   
  

    # Get Certificate & print out its properties
    $Cert = Get-AutomationCertificate -Name $MyCert
    if ($Cert -eq $null)
    {
        Write-Output "Certificate entered: $MyCert does not exist in the automation service. Please create one `n"   
    }
    else
    {
        $Thumbprint = $Cert.Thumbprint
        
      #  Write-Output "Certificate Properties: "
      #  Write-Output "Thumbprint: $Thumbprint"
    }

        #Set and Select the Azure Subscription
         Set-AzureSubscription `
            -SubscriptionName "My Azure Subscription" `
            -Certificate $Cert `
            -SubscriptionId $SubscriptionID `

        #Select Azure Subscription
         Select-AzureSubscription `
            -SubscriptionName "My Azure Subscription"


       Write-Output "-------------------------------------------------------------------------"

       Write-Output "Starting the Shutdown NOW!"

       Get-AzureVM | select name | ForEach-Object {
        $StopOutPut = Stop-AzureVM -ServiceName $_.Name -Name $_.Name -Force
           Write-Output "Shutting down :  $_.Name "
           #Write-Output $StopOutPut
           
           }

       Write-Output "-------------------------------------------------------------------------"
 
}