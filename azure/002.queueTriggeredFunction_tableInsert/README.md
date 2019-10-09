# Queue Triggered and inserting to Table Storage Function App

## Architecture
<img src="https://docs.microsoft.com/ko-kr/azure/architecture/patterns/_images/queue-based-load-leveling-function.png"></img>
<p>It implements <b>https://github.com/rudgh1027/cloud/tree/master/azure/001.queueTriggeredFunction</b></p>
<p>So, I recommand you to follow everything in previous practice.</p>

# Procedure
If you complete all procedure in privious practice, comtinue following procedure.

## 1. Get source from github
<pre><code>
git init source           #source can be replaced with other directory name you want
cd source
git remote add -f origin https://github.com/rudgh1027/cloud.git
git config core.sparseCheckout true
echo "azure/002.queueTriggeredFunction_tableInsert/*" >> .git/info/sparse-checkout
git pull origin master
cd azure/002.queueTriggeredFunction_tableInsert/

</code></pre>

## 2. Editting Parameter Name
<pre><code>
## complete names of resources
vi exported.dat

</code></pre>

## 3. Deploy Service Bus Queue and Azure Function App
Just run
<pre><code>
## deploy queue
./deployq.sh
## deploy function app
./deployFunc.sh

</code></pre>

## 4. Make Project
<pre><code>
./makeProj.sh
## Select a worker runtime:
## 1. dotnet
## 2. node
## 3. python
## 4. powershell (preview)
## Choose option: 1            Select 1

</code></pre>

## 5. Deploy Table Storage

<pre><code>
az storage table create --name {yourTableStorageName} --account-name {yourStorageAccountName}

</code></pre>

You can reuse storage account already created in previous practice.

Determine your table storage name and replace {yourTableStorageName} with that.

output
<pre><code>
{
  "created": true
}

</code></pre>

## 6. Editting {FunctionAppName}.cs Source
<p>Open ~/source/azure/002.queueTriggeredFunction_tableInsert/(projectname).cs</p>
<p>Now our codes are</p> 

<pre><code>
using System;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Extensions.Logging;

namespace funcgkim0012
{
    public static class funcgkim0012
    {
        [FunctionName("funcgkim0012")]
        public static void Run([ServiceBusTrigger("yourqueuename", Connection = "MyServiceBusConnection")]string myQueueItem, ILogger log)
        {
            log.LogInformation($"C# ServiceBus queue trigger function processed message: {myQueueItem}");
        }
    }
}

</code></pre>

You should add some codes like this.
<pre><code>
using System;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using Microsoft.Azure.WebJobs.Extensions.Storage;

namespace funcgkim0012
{
    public class MyHealthData
    {
        public string PartitionKey { get; set; }
        public string RowKey { get; set; }
        public int heat { get; set; }
        public int heartbaet { get; set; }
    }
    public static class funcgkim0012
    {
        [FunctionName("funcgkim0012")]
        [return: Table("gkHealthCareData")]
        public static MyHealthData Run([ServiceBusTrigger("q-gkim-02", Connection = "MyServiceBusConnection")]string myQueueItem, ILogger log)
        {
            MyHealthData md = JsonConvert.DeserializeObject&lt;MyHealthData&gt;(myQueueItem);
            log.LogInformation($"C# ServiceBus queue trigger function processed message: {myQueueItem}");
            return md;
        }
    }
}

</code></pre>
<small>reference: https://docs.microsoft.com/ko-kr/azure/azure-functions/functions-bindings-storage-table</small>

## 7. Import Nuget Package
<pre><code>
## In your azure cloud shell, cd ..../{yourfunctionapp}/
## Import package of webjobs storage extension
dotnet add package Microsoft.Azure.WebJobs.Extensions.Storage --version 3.0.4
## Import package of Json
dotnet add package Newtonsoft.Json --version 11.0.2

</code></pre>
## 8. Local Build
<pre><code>
## bash
func start --build

</code></pre>

If error occur saying 
<pre><code>
[10/8/19 8:44:12 AM] A host error has occurred
[10/8/19 8:44:12 AM] System.Private.CoreLib: Could not load file or assembly 'Microsoft.Azure.WebJobs.Extensions.Storage, Version=3.0.8.0, Culture=neutral, PublicKeyToken=.........'. Could not find or load a specific file. (Exception from HRESULT: 0x80131621). System.Private.CoreLib: Could not load file or assembly 'Microsoft.Azure.WebJobs.Extensions.Storage, Version=3.0.8.0, Culture=neutral, PublicKeyToken=........'.
[10/8/19 8:44:12 AM] Stopping JobHost
Value cannot be null.
Parameter name: provider
</code></pre>
<p>Then you have to use other package version of <b>Microsoft.Azure.WebJobs.Extensions.Storage</b>.</p> 
<p>This error was occured because visual studio code and package version didn't match.</p>
<p>I recommand 3.0.4 version</p>

### 8.1 Test_1
Go to "~/source/azure/001.queueTriggeredFunction/sender/"
<p>Open Program.cs</p>
<pre><code>
...
      static string ServiceBusConnectionString="....";
      static string QueueName="..."; 
...

</code></pre>
Insert your queue name and connectionString.
Save and run "dotnet run"
<pre><code>
## bash
dotnet run

</code></pre>
In your terminal running azure function app project, you can see a message log.

## 9. Deploy To Azure Function
Go to "~/source/azure/001.queueTriggeredFunction/{FunctionAppName}"
<pre><code>
## bash
func azure functionapp publish {FunctionAppName}

</code></pre>

### 9.1 Test_2
Go to "~/source/azure/001.queueTriggeredFunction/sender/"
<pre><code>
## bash
dotnet run

</code></pre>
