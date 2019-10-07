# Initailize Parameters
resourcegroupName=`cat exported.dat | grep resourcegroupName | awk -F "=" '{printf $2}'`
location=`cat exported.dat | grep location | awk -F "=" '{printf $2}'`
namespaceName=`cat exported.dat | grep namespaceName | awk -F "=" '{printf $2}'`
qname=`cat exported.dat | grep qname | awk -F "=" '{printf $2}'`
echo qname > ./qname.dat

# Create a resource group
az group create --name $resourcegroupName --location $location

# Create a Service Bus messaging namespace with a unique name
az servicebus namespace create --resource-group $resourcegroupName --name $namespaceName --location $location

# Create a Service Bus queue
az servicebus queue create --resource-group $resourcegroupName --namespace-name $namespaceName --name $qname

# Get the connection string for the namespace
connectionString=$(az servicebus namespace authorization-rule keys list --resource-group $resourcegroupName --namespace-name $namespaceName --name RootManageSharedAccessKey --query primaryConnectionString --output tsv)

# Export ConnectionString
echo $connectionString > ./conn.dat
