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
> When clients call that public IP then they will be routed to the pod behind the service.
<pre><code>
curl http://&lt;External IP&gt;:80

</code></pre>
- <code>kubectl get services</code> : List all services.


# Pod
## About
- Collection of one or more containers(Each containers have a **hard dependency**)
- Logical Application that has **Several containers and volums**, **shared namespace**, **One IP per pod**
<img src="https://cdn.qwiklabs.com/tzvM5wFnfARnONAXX96nz8OgqOa1ihx6kCk%2BelMakfw%3D"></src>
>reference : https://cdn.qwiklabs.com/tzvM5wFnfARnONAXX96nz8OgqOa1ihx6kCk%2BelMakfw%3D

## Creating Pod
- Create Pod
<pre><code>kubectl create -f pods/monolith.yaml

</code></pre>

- Geting imformation from pod
<pre><code>
// List all pods running in the default namespace
kubectl get pods
// Get imformation about monolith pod.
kubectl describe pods monolith

</code></pre>

## Interacting with pods
- Open two terminal
- Terminal 1 : Set port forwarding ( Mapping a local port to a port inside the monolith pod )
<pre><code>
kubectl port-forward monolith 10080:80

</code></pre>
- Terminal 2 : Talking with pod
<pre><code>
curl http://127.0.0.1:10080
// result : hello

</code></pre>
- Terminal 2 : Trying talking to secure endpoint.
<pre><code>
curl http://127.0.0.1:10080/secure
// We have to get an auth token

</code></pre>
- Terminal 2 : Logging in
<pre><code>
TOKEN=$(curl http://127.0.0.1:10080/login -u user|jq -r '.token')
// password : 'password'

curl -H "Authorization: Bearer $TOKEN" http://127.0.0.1:10080/secure
// We can get a reponse back from our application

</code></pre>
- View logs
<pre><code>
kubectl logs monolith
// real time logging
kubectl logs -f monolith

</code></pre>
- Run interactive shell inside the pod for troubleshoot.
<pre><code>
kubectl exec monolith --stdin --tty -c monolith /bin/sh
ping -c 3 google.com
exit

</code></pre>

# Services
## About
- Service provide stable endpoints for pods (Pods are not persistent)
<img src="https://cdn.qwiklabs.com/Jg0T%2F326ASwqeD1vAUPBWH5w1D%2F0oZn6z5mQ5MubwL8%3D"></img>
- Use lable to seleect pods
- internal or external IPs
- Access Level
  - Cluster IP(internal) : default type, Only visible inside the cluster
  - Nodeport : Gives each node in cluster an externally accessible IP
  - Loadbalancer : Add load balancer from the cluster
  
  ## Creating a service
  
