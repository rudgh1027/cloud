##############
## RG CREATE ##
##############
loc=                ##### INSERT YOUR VALUE!!!!
rgname=             ##### INSERT YOUR VALUE!!!!

az group create --location $loc --name $rgname

##############
## VM CREATE ##
##############

adminname=          ##### INSERT YOUR VALUE!!!!
vmname=             ##### INSERT YOUR VALUE!!!!

az vm create \
  --resource-group $rgname \
  --name $vmname \
  --image UbuntuLTS \
  --admin-username $adminname \
  --generate-ssh-keys

####################
## DOCKER EXTENSION ##
####################

az vm extension set --name DockerExtension --publisher Microsoft.Azure.Extensions --resource-group $rgname --vm-name $vmname


###################
## CONNECT TO VM ##
###################

pip=$(az vm list-ip-addresses --name $vmname | jq ".[].virtualMachine.network.publicIpAddresses[0].ipAddress" -r)
ssh $adminname@$pip
