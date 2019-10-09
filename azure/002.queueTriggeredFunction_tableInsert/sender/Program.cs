using System;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Azure.ServiceBus;
using System.IO;
using System.Diagnostics;
using Newtonsoft.Json;

namespace sender
{
    class Program
    {
        static string ServiceBusConnectionString="Endpoint=sb://ns-gkim-02.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=uA87z/Cad9/7Okx8B/jIZvEHosV8xnhXnXhhTDpLE9Y=";
        static string QueueName="q-gkim-02"; 
        static IQueueClient queueClient;

        class MyHealthData
        {
            public string PartitionKey { get; set; }
            public string RowKey { get; set; }
            public int heat { get; set; }
            public int heartbaet { get; set; }
        }

        static void Main(string[] args)
        {
            MainAsync().GetAwaiter().GetResult();
        }
        static async Task MainAsync()
        {
            const int numberOfMessages = 100;
            queueClient = new QueueClient(ServiceBusConnectionString, QueueName);

            Console.WriteLine("======================================================");
            Console.WriteLine("Press ENTER key to exit after sending all the messages.");
            Console.WriteLine("======================================================");

            // Send messages.
            await SendMessagesAsync(numberOfMessages);

            Console.ReadKey();

            await queueClient.CloseAsync();
        }
        static async Task SendMessagesAsync(int numberOfMessagesToSend)
        {
            try
            {
                for (var i = 0; i < numberOfMessagesToSend; i++)
                {
                    // Create a new message to send to the queue.
                    Random r = new Random();

                    MyHealthData md1 = new MyHealthData();
                    md1.PartitionKey = "gkm177439372";
                    md1.RowKey = DateTime.Now.ToString("yyyy-MM-dd-HH-mm-ssss")+ r.Next(1,999).ToString();
                    md1.heat = r.Next(30, 45);
                    md1.heartbaet = r.Next(80,150);

                    string messageBody = JsonConvert.SerializeObject(md1);
                    var message = new Message(Encoding.UTF8.GetBytes(messageBody));

                    // Write the body of the message to the console.
                    Console.WriteLine($"Sending message: {messageBody}");
                    // Send the message to the queue.
                    await queueClient.SendAsync(message);
                }
            }
            catch (Exception exception)
            {
                Console.WriteLine($"{DateTime.Now} :: Exception: {exception.Message}");
            }
        }
    }
}
