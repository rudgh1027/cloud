projName=`cat exported.dat | grep projName | awk -F "=" '{printf $2}'`
resourcegroupName=`cat exported.dat | grep resourcegroupName | awk -F "=" '{printf $2}'`
connectionString=`cat conn.dat | awk '{printf $0}'`
funcName=`cat exported.dat | grep funcName | awk -F "=" '{printf $2}'`

func init $projName
cp ./host.json ./$projName/host.json
cd ./$projName
az functionapp config appsettings set -n $funcName -g $resourcegroupName --settings "MyServiceBusConnection=$connectionString"
func azure functionapp fetch-app-settings $funcName
func new --name $projName --template "servicebusqueuetrigger"
echo ../qname.dat
code .
