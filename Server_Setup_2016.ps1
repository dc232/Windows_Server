#################################################
#GLOBAL VARS
#################################################

$IPAddr="10.0.2.11" #apperantly this is the way to delcare variables in powershell this is the inverse of what happens in linux
$Default_Gateway="10.0.0.1"
$Domain_Name="CLOUD.com"
$Database_Path="C:\Windows\NTDS"
$Log_Path="C:\Windows\NTDS"
$Domain_and_Forest_Mode="Win2012"
$SysvolPath="C:\Windows\SYSVOL"

function ip_addressing {
echo "Changing IP Address to $IPAddr"
sleep 2
New-NetIPAddress -InterfaceIndex 3 -IPAddress $IPAddr -PrefixLength 8 -DefaultGateway $Default_Gateway
}

function services {
echo "Changings status of the follwing services  FDResPub SSDPSRV upnphost for automated network discovery"
Set-Service -Name "FDResPub" -Status Running -StartupType Automatic -PassThru #same as systemctl start nginx in linux or service nginx start
Set-Service -Name "SSDPSRV" -Status Running -StartupType Automatic -PassThru
Set-Service -Name "upnphost" -Status Running -StartupType Automatic -PassThru
#https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/set-service?view=powershell-5.1
}

function AD_Setup {
echo "Installing AD Domain Services"
sleep 2
Install-WindowsFeature AD-Domain-Services
echo "Importing ADDS Deployment Module"
Import-Module ADDSDeployment 
echo "Promoting Server to a Domain Controller"
Install-ADDSForest -DomainName $Domain_Name -Confirm -DatabasePath $Database_Path -DomainMode $Domain_and_Forest_Mode -Force -ForestMode $Domain_and_Forest_Mode -InstallDns -LogPath $Log_Path -SysvolPath $SysvolPath
#same as sudo apt-get install nginx -y/ yum install nginx -y in linux
}

echo "This is a script designed for windows server to Do Ip addressing make the server network discoverable and promote the server to an AD"
sleep 10

ip_addressing
services
AD_Setup


#check windows features get-windowsfeature
#get-netipinterface shows interface alias
#get-netadapter - shows interface index
#services get-sevice

#Set-DnsClientServerAddress https://www.howtogeek.com/112660/how-to-change-your-ip-address-using-powershell/