resourcegroupName=`cat exported.dat | grep resourcegroupName | awk -F "=" '{printf $2}'`
location=`cat exported.dat | grep location | awk -F "=" '{printf $2}'`
storageaccName=`cat exported.dat | grep storageaccName | awk -F "=" '{printf $2}'`
funcName=`cat exported.dat | grep funcName | awk -F "=" '{printf $2}'`

az group create --name $resourcegroupName --location $location

az storage account create --name $storageaccName --location $location --resource-group $resourcegroupName --sku Standard_LRS

az functionapp create --resource-group $resourcegroupName --consumption-plan-location $location \
--name $funcName  --storage-account  $storageaccName --runtime dotnet


