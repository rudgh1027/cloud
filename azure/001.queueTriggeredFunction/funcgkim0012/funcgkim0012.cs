using System;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Extensions.Logging;

namespace funcgkim0012
{
    public static class funcgkim0012
    {
        [FunctionName("funcgkim0012")]
        public static void Run([ServiceBusTrigger("q-gkim-39023", Connection = "MyServiceBusConnection")]string myQueueItem, ILogger log)
        {
            log.LogInformation($"C# ServiceBus queue trigger function processed message: {myQueueItem}");
        }
    }
}
