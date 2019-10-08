# Queue Triggered Service Bus Queue

## Architecture
<img src="https://docs.microsoft.com/ko-kr/azure/architecture/patterns/_images/queue-based-load-leveling-pattern.png"></img>
<p>We are going to make <b>dotnet console application as task</b>, <b>azure function app as service</b>.</p>

# Procedure
<p>This pratice is optimized for <b>bash shell and azure cli in Azure Cloud Shell.</b> Go to azure portal and run azure cloud shell</p>

## Get source from github
<pre><code>
git init {source}           #{source} can be replaced with other directory name you want
cd source
git remote add -f origin https://github.com/rudgh1027/cloud.git
git config core.sparseCheckout true
echo "azure/001.queueTriggeredFunction/*" >> .git/info/sparse-checkout
git pull origin master
cd azure/001.queueTriggeredFunction/
</code></pre>

## Editting Parameter Name
<pre><code>
## complete names of resources
vi exported.dat
</code></pre>

## Deploy Service Bus Queue and Azure Function App
Just run
<pre><code>
## deploy queue
./deployq.sh
## deploy function app
./deployFunc.sh
</code></pre>

## Make Project
<pre><code>
./makeProj.sh
## Select a worker runtime:
## 1. dotnet
## 2. node
## 3. python
## 4. powershell (preview)
## Choose option: 1            #Select 1
</code></pre>

## Editting {FunctionAppName}.cs Source
Now we can see Visual Studio code edittor.
Open (projectname).cs
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
        public static void Run([ServiceBusTrigger("myqueue", Connection = "")]string myQueueItem, ILogger log)
        {
            log.LogInformation($"C# ServiceBus queue trigger function processed message: {myQueueItem}");
        }
    }
}
</code></pre>
<p>Replace myqueue with your queue name in your sesrvice bus namespace.
In my code, I already define connectionString name, <b>MyServiceBusConnection</b>.
So replace "" with "MyServiceBusConnection".</p>
<p>Now our code is</p> 

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
<p>Open Program.cs and insert your queue name and connectionString.</p>
<pre><code>
...
      static string ServiceBusConnectionString="....";
      static string QueueName="..."; 
...
</code></pre>

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
