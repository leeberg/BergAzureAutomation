
$VMLocation = "C:\DemoVMs"
$VMNetwork = "External"
$VHDLocation = "C:\Runbooks\NANO"

function CreateNanoServer {
param($VMName, $VHDFile, $VMMemory, $VMDiskSize )

    # Create Nano Server 001
 
    New-VM -Name $VMName -MemoryStartupBytes $VMMemory -SwitchName $VMNetwork -Path $VMLocation -NoVHD 
    New-Item "$VMLocation\$VMName\Virtual Hard Disks" -ItemType directory
    Copy-Item "$VHDLocation\$VHDFile" -Destination "$VMLocation\$VMName\Virtual Hard Disks"
    Add-VMHardDiskDrive -VMName $VMName -Path "$VMLocation\$VMName\Virtual Hard Disks\$VHDFile"

}

Write-Output "Staring to Create Nano Server!" 

#Run the Actions!
Write-Output "Staring to Create Nano Server 1!" 
CreateNanoServer -VMName "Nano-01" -VHDFile "Nano-01.vhd" -VMMemory 512MB -VMDiskSize 5GB


Write-Output "Staring to Create Nano Server 2" 
CreateNanoServer -VMName "Nano-02" -VHDFile "Nano-02.vhd" -VMMemory 512MB -VMDiskSize 5GB


Write-Output "Staring to Create Nano Server 3!" 
CreateNanoServer -VMName "Nano-03" -VHDFile "Nano-03.vhd" -VMMemory 512MB -VMDiskSize 5GB


Write-Output "Staring to Create Nano Server 4!" 
CreateNanoServer -VMName "Nano-04" -VHDFile "Nano-04.vhd" -VMMemory 512MB -VMDiskSize 5GB


Write-Output "Done!" 
