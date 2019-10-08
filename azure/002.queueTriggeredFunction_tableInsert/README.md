# Queue Triggered and inserting to Table Storage Function App

## Architecture
<img src="https://docs.microsoft.com/ko-kr/azure/architecture/patterns/_images/queue-based-load-leveling-function.png"></img>
<p>It implements <b>https://github.com/rudgh1027/cloud/tree/master/azure/001.queueTriggeredFunction</b></p>
<p>So, you must create all resource and dotnet application project in previous posting, <b>https://github.com/rudgh1027/cloud/tree/master/azure/001.queueTriggeredFunction</b></p>

# Procedure
If you complete all procedure in privious posting, comtinue following procedure.

## Deploy Table Storage


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

## Local Build
<pre><code>
## bash
func start --build
</code></pre>

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
