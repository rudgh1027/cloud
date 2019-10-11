# Overview
- Provision a complete Kubernetes cluster using Kubernetes Engine.
- Deploy and manage Docker containers using kubectl.
- Break an application into microservices using Kubernetes' Deployments and Services.

# Kubernetes
## Start Google kubernetes Engine
- Lonin to GCP and open cloud shell
- Setting the zone

<pre><code>
gcloud config set compute/zone us-central1-b

</code></pre>

- After you set the zone, start up a cluster for use in this lab:

<pre><code>
gcloud container clusters create io

</code></pre>

- Get the sample code

<pre><code>
git clone https://github.com/googlecodelabs/orchestrate-with-kubernetes.git
cd orchestrate-with-kubernetes/kubernetes
ls

</code></pre>

## Quick Demo
- <code>kubectl create</code> : Launch a single instance of container
<pre><code>
kubectl create deployment nginx --image=nginx:1.10.0

</code></pre>
- <code>kubectl get pods </code> : View all running containers
- <code>kubectl expose</code> : Expose running container outside of Kubernetes
<pre><code>
// Create an externel load balancer with PIP
kubectl expose deployment nginx --port 80 --type LoadBalancer

</code></pre>
>> When clients call that public IP then they will be routed to the pod behind the service.
