#Login-AzureRmAccount
#first, save the password you will use to a secure flat file...
$vmUser = "administrator99"
$passFile = ".\vmUserPass4.txt"
$azureClassicService = "DenService3d"
$virtualNetwork = "PerfectPetd"
$subnetName = "BackEndd"
$vmName = "ABCD-IVVd"
$vmSize="Standard_F4"


# Existing service and virtual network


ConvertTo-SecureString   "xashdfwfd98vcy1234!£6$%^" -AsPlainText -Force | ConvertFrom-SecureString | Out-File -FilePath $passFile -Force

# next works fine...

New-AzureService -ServiceName $azureClassicService -Label "MyTestService" -Location "West Europe"


#First create your dependencies: net and subnet
# easiest to do this in CLI
Get-Date
azure network vnet create --vnet $virtualNetwork -e 192.168.0.0 -i 16 -n $virtualNetwork -p 192.168.1.0 -r 24 -l "East US"
Get-Date
#azure network vnet delete --vnet $virtualNetwork


azure network vnet subnet create -t $virtualNetwork -n $subnetName -a 192.168.2.0/24
Get-Date
$imageFamilyName ="Windows Server 2012 R2 Datacenter"
$imageFamilyName 
$imageName = Get-AzureVMImage | where { $_.ImageFamily -eq $imageFamilyName } | sort PublishedDate -Descending | select -ExpandProperty ImageName -First 1
$imageName


$vmConfig = New-AzureVMConfig -Name $vmName -InstanceSize $vmSize -ImageName $imageName
$vmConfig
$vmConfig | Add-AzureProvisioningConfig -Windows -AdminUsername administrator99 -Password (get-content $passFile) | Set-AzureSubnet $subnetName
Get-Date
New-AzureVM -ServiceName $azureClassicService -VNetName $virtualNetwork -VMs $vmConfig -Location "East US"
Get-Date
<#

Add-AzureProvisioningConfig -VM $vmName


$cred1=Get-Credential -UserName  –Message "Type the name and password of the local administrator account."
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
New-AzureVM –ServiceName $svcname -VMs $vmConfig -VNetName $vnetname

#>
