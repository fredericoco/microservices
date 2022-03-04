# Kubernetes abc
### What is Kubernetes?
Kubernetes (also known as K8) is used to orchestrate containerised applications to run on a cluster of hosts.The K8s system automates the deployment and management of cloud native applications using on-premises infrastructure or public cloud platforms.

 It distributes application workloads across a Kubernetes cluster and automates dynamic container networking needs. Kubernetes also allocates storage and persistent volumes to running containers, provides automatic scaling, and works continuously to maintain the desired state of applications, providing resiliency. It's like ansible but for docker containers.

 In order to work K8 requires one master and several worker nodes. The worker nodes will have a kubelet and kube proxy on them, this makes sure that it functions. kubectl is used to control the master node.
### Benefits and How does it benefit the business
The benefits of kubernetes are:
- Portability: Containers are portable across a range of environments from virtual environments to bare metal. Kubernetes is supported in all major public clouds, as a result, you can run containerized applications on K8s across many different environments.
  
- Integration and extensibility: Kubernetes is extensible to work with the solutions you already rely on, including logging, monitoring, and alerting services. The Kubernetes community is working on a variety of open source solutions complementary to Kubernetes, creating a rich and fast-growing ecosystem.
  
- Cost efficiency: Kubernetes' inherent resource optimization, automated scaling, and flexibility to run workloads where they provide the most value means your IT spend is in your control.
  
- Scalability: Cloud native applications scale horizontally. Kubernetes uses “auto-scaling,” spinning up additional container instances and scaling out automatically in response to demand.
- API-based: The fundamental fabric of Kubernetes is its REST API. Everything in the Kubernetes environment can be controlled through programming.

- Simplified CI/CD: CI/CD is a DevOps practice that automates building, testing and deploying applications to production environments. Enterprises are integrating Kubernetes and CI/CD to create scalable CI/CD pipelines that adapt dynamically to load.
  
### Use cases
Airbnb initially used monolith architecture on their website called Monorail. As the company grew and there were more commits to the monolith, it would spend an average of 15 hours per week being blocked due to reverts and rollbacks.

To deal with this issue and the new scaling issue, Airbnb transitioned to a using kubernetes in 2017 in the cloud. Ths simplified the work of the engineers at airbnb and now it facilitates 500 implementations per day.

Instead of commiting to one monolith and dealing with issues relating to rollback, having several clusters and thosand of nodes makes it easier to commit changes.

https://www.altoros.com/blog/airbnb-deploys-125000-times-per-year-with-multicluster-kubernetes/

### K8 diagram
![kubernetes_architecture_diagram_explained](https://user-images.githubusercontent.com/39882040/156428941-c05497d4-e981-42ff-8dd4-68abdda6a755.png)
The diagram above shows the architecture of a k8 clusture.
### What is self healing with K8
Self-healing is a feature provided by the Kubernetes open-source system. If a containerized app or an application component fails or goes down, Kubernetes re-deploys it to retain the desired state.
### K8 roll back - how to use it
 Kubernetes has a built-in rollback mechanism. There are several strategies when it comes to deploying apps into production. In Kubernetes, rolling updates are the default strategy to update the running version of your app. The rolling update cycles previous Pod out and bring newer Pod in incrementally.

 The command is `kubectl rollout undo deploy my-deployment-name -n my-namespace`.

 https://learnk8s.io/kubernetes-rollbacks

 `kubectl get svc` to see clusters running

 kubernetes commands:
 - `kubectl create -f file.yml` - This command creates a resource from a yml file.
 - `kubectl get pods` shows the status of the pods
 - `kubectl delete all --all` deletes all the pods
 - `kubectl get pv or pvc` gets the status of the persistant volume or persistent volume claim

```
# k8 is a yml file
# we are going to create a deployment for our nginx-image
# we will create 3 pods with this deployment
# kubectl get name-service - deploy/deployment - service/svc - pods
# kubectl create -f file.yml
# kubectl delete name-service deploy deploy-name

# first word lowercase, second word bgins caps

apiVersion: apps/v1

kind: Deployment # pod, service replicaset ASG

# metadata to name your deployment -case insensitive
metadata:
  name: node
spec:
  # labels and selectors are the communication channels between micro-services 
  selector:
    matchLabels:
      app: nginx
  replicas: 3
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: fredericoco121/docker_eng103a

          ports:
            - containerPort: 80

          imagePullPolicy: Always
---
apiVersion: v1
kind: Service
metadata:
  name: nginx
spec:
  type: NodePort
  selector:
    app: nginx
  ports:
      # By default and for convenience, the `targetPort` is set to the same value as the `port` field.
    - port: 80
      targetPort: 80
      # Optional field
      # By default and for convenience, the Kubernetes control plane will allocate a port from a range (default: 30000-32767)
      nodePort: 30000
```
### App and db setup
```
# create a mongo service that the app can reference and point to
apiVersion: v1
kind: Service
metadata:
  name: mongo
  labels:
    app: mongo
spec:
  ports:
  - port: 27017
    name: http
  selector:
    app: mongo
--- # indicates it's a new file

# actually create the database deployment for pod
apiVersion: apps/v1

kind: Deployment

metadata:
  name: mongo
spec:
  selector:
    matchLabels:
      app: mongo
  replicas: 1
  template:
    metadata:
      labels:
        app: mongo
    spec:
      containers:
        - name: mongo
          image: mongo
          ports:
            - containerPort: 27017
          volumeMounts:
            - name: mongovolume
              mountPath: /data/db
      volumes:
        - name: mongovolume
          persistentVolumeClaim:
            claimName: mongo-db
--- # indicates it's a new file

# launching our application
apiVersion: apps/v1

kind: Deployment


metadata:
  name: app
spec:
  selector:
    matchLabels:
      app: app
  replicas: 3
  template:
    metadata:
      labels:
        app: app
    spec:
      containers:
        - name: app
          image: fredericoco121/small_app_update
          ports:
            - containerPort: 80
          imagePullPolicy: IfNotPresent
          env: 
          - name: DB_HOST
            value: 'mongodb://mongo:27017/posts'
--- # indicates it's a new file

# create the loadbalancer for app
apiVersion: v1
kind: Service

metadata:
  name: app-svc
  name: default
spec:
  selector:
    app: app
  ports:
  - port: 80
    targetPort: 3000
    nodePort: 30000
    protocol: TCP
  selector:
    app: app
  sessionAffinity: None
  type: LoadBalancer
```
Setting up the persistent volume and persistent volume claim.

```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: mongovolume
  labels:
    type: local
spec:
  storageClassName: manual
  capacity:
    storage: 150Mi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/mnt/data"
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mongo-db
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 256Mi
```