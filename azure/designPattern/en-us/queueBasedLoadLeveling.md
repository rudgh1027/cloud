# Discribe this pattern
 reference : https://docs.microsoft.com/en-us/azure/architecture/patterns/queue-based-load-leveling
 
## 1. Feature
    - Queue evenly transfer messages with certain speed. So that it can prevent service disorder caused by high traffic.
    - We can also check change of scales depending on request.
    
## 2. Advantages
    - In case of service disorder, clients could send request due to queue as buffer.
    - We could scale number of queues and services. As a result, we could maximize availablity.
    - We could optimize cost.vk
    
## 3. Requirement
    - Need to control message processing speed
    - Asynchronous messaging mechanism is needed
    - It can be degraded because of competition caused by auto scaling

# Use case

## 1. Faced Problen
<img src="https://docs.microsoft.com/ko-kr/azure/architecture/patterns/_images/queue-based-load-leveling-overwhelmed.png"></img>
    - Service can fail, if requests from web app to datastore are increased
   
## 2. Solution
<img src="https://docs.microsoft.com/ko-kr/azure/architecture/patterns/_images/queue-based-load-leveling-function.png"></img>
    - It could control writing speed to datastore using Service bus queue and Function app.
   
# Example
## 1. Plan
- Suppose to Health care system that collects body heat and heartbeat in seconds.
- Use Azure table storage as datastore
- Case 1 : Console application -> Table storage (Several request are expected to fail, If 100-thousands of job have been requested)
- Case 2 : Console application -> Service bus queue -> Function app -> Table storage
  - All requests will complete due to queue as buffer.

## 2. Practice
It already wrote in github repository.
https://github.com/rudgh1027/cloud/blob/master/azure/002.queueTriggeredFunction_tableInsert/README.md

# Lessen & Learn
- Tesing on Case 1 : Pass
  - Imposible to make enough transaction : Console appication can send only one or two messages to queue, but table storage can write 20-thousands of data per 1 second.
  - CosmosDB is recommanded rather than Table storage : over 10,000,000 TPS could be processed and guarantee of recovery...  
  - reference : https://docs.microsoft.com/en-us/azure/cosmos-db/table-support
- personal perspective
  - Provided example has no meaning as architecture designed pettern. If you want to use resources that can be IO buffer, Redis cache is better.
  - reference : https://azure.microsoft.com/en-us/services/cache/
  - This pettern can be used POC system or data analyzing systems bottleneck can occur.
   <img src="https://docs.microsoft.com/ko-kr/azure/architecture/example-scenario/ai/media/mass-ingestion-newsfeeds-architecture.png"></img>
  - reference : https://docs.microsoft.com/en-us/azure/architecture/example-scenario/ai/newsfeed-ingestion
