#Login-AzureRmAccount

$family="Windows Server 2012 R2 Datacenter"
$family 
$image=Get-AzureVMImage | where { $_.ImageFamily -eq $family } | sort PublishedDate -Descending | select -ExpandProperty ImageName -First 1
$vmname="LOB1"
$vmsize="Large"
$vm1=New-AzureVMConfig -Name $vmname -InstanceSize $vmsize -ImageName $image

$cred1=Get-Credential –Message "Type the name and password of the local administrator account."
$cred2=Get-Credential –Message "Now type the name (not including the domain) and password of an account that has permission to add the machine to the domain."
$domaindns="corp.contoso.com"
$domacctdomain="CORP"
$vm1 | Add-AzureProvisioningConfig -AdminUsername $cred1.Username -Password $cred1.GetNetworkCredential().Password -WindowsDomain -Domain $domacctdomain -DomainUserName $cred2.Username -DomainPassword $cred2.GetNetworkCredential().Password -JoinDomain $domaindns

$vm1 | Set-AzureSubnet -SubnetNames "FrontEnd"

$disksize=200
$disklabel="LOBData"
$lun=0
$hcaching="ReadWrite"
$vm1 | Add-AzureDataDisk -CreateNew -DiskSizeInGB $disksize -DiskLabel $disklabel -LUN $lun -HostCaching $hcaching

$svcname="Azure-TailspinToys"
$vnetname="AZDatacenter"
New-AzureVM –ServiceName $svcname -VMs $vm1 -VNetName $vnetname