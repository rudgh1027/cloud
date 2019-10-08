# Queue Triggered and inserting to Table Storage Function App

## Architecture
<img src="https://docs.microsoft.com/ko-kr/azure/architecture/patterns/_images/queue-based-load-leveling-function.png"></img>
<p>It implements <b>https://github.com/rudgh1027/cloud/tree/master/azure/001.queueTriggeredFunction</b></p>
<p>So, you must create all resource and dotnet application project in previous practice, <b>https://github.com/rudgh1027/cloud/tree/master/azure/001.queueTriggeredFunction</b></p>

# Procedure
If you complete all procedure in privious practice, comtinue following procedure.

## Deploy Table Storage

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

## Editting {FunctionAppName}.cs Source
<p>Open (projectname).cs</p>
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

namespace funcgkim0012
{
    //Define entity
    public class MyPoco
    {
        public string PartitionKey { get; set; }
        public string RowKey { get; set; }
        public string Text { get; set; }
    }
    public static class funcgkim0012
    {
        // Change return type as MyPoco and declare [return: Table("MyTable")]
        [FunctionName("funcgkim0012")]
        [return: Table("MyTable")]
        public static MyPoco Run([ServiceBusTrigger("yourqueuename", Connection = "MyServiceBusConnection")]string myQueueItem, ILogger log)
        {
            log.LogInformation($"C# ServiceBus queue trigger function processed message: {myQueueItem}");
            //Return entity
            return new MyPoco { PartitionKey = "Http", RowKey = Guid.NewGuid().ToString(), Text = input.Text };
        }
    }
}
</code></pre>
<small>reference: https://docs.microsoft.com/ko-kr/azure/azure-functions/functions-bindings-storage-table</small>

## Import Nuget Package
<pre><code>
## In your azure cloud shell, cd ..../{yourfunctionapp}/
dotnet add package Microsoft.Azure.WebJobs.Extensions.Storage --version 3.0.4
</code></pre>
## Local Build
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

### Test_1
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

## Deploy To Azure Function
Go to "~/source/azure/001.queueTriggeredFunction/{FunctionAppName}"
<pre><code>
## bash
func azure functionapp publish {FunctionAppName}
</code></pre>

### Test_2
Go to "~/source/azure/001.queueTriggeredFunction/sender/"
<pre><code>
## bash
dotnet run
</code></pre>
