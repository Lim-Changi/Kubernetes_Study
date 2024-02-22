# MacOS

# kubectl
brew install kubectl

# minikube
brew install minikube

# base k8s set
minikube start

# get all k8s pods
kubectl get po -A
# kube-system Namespace 에 K8s 를 구성하는 Resource 에 대한 정보를 확인할 수 있다
# ex) kube-apiserver, kube-proxy, kube-controller, etc..

# Deployment Creation & Exposure
kubectl create deployment APP_NAME --image=DOCKER_HUB_IMAGE
kubectl expose deployment APP_NAME --type=NodePort --port=PORT_NUM

## All Service Types
# ClusterIP (기본 형태)
# NodePort -> 외부로 Expose 할때 필요
# LoadBalancer
# ExternalName

# get default running pod
kubectl get pod


# describe pod
kubectl describe pod/POD_NAME


# get all services by name
kubectl get services APP_NAME

# get all deployments
kubectl get deployments

# delete service
kubectl delete service APP_NAME

# delete deployment
kubectl delete deployments APP_NAME


# start local tunnelling by minikube
minikube service APP_NAME # Docker Desktop 에서 확인 가능

# kubectl alias to k
alias k=`kubectl`


# ReplicaSet Scaling
kubectl replace -f replicaset.yml
kubectl scale --replicas=REPLICA_NUM -f replicaset.yml
kubectl scale --replicas=REPLICA_NUM rs/REPLICASET_NAME

# Deployment Rolling Update
## Change Image Version in YAML & apply
# Check Rolling Update Progress
kubectl describe deployment DEPLOYMENT_NAME
kubectl rollout status deployment DEPLOYMENT_NAME

# Deployment Rollback
kubectl rollout undo deployment DEPLOYMENT_NAME

#### ShortTerm
# pod -> po
# service -> svc
# deployment -> deploy
# namespace -> ns
# configmap -> cm
# ingress -> ing
# replicaset -> rs

# get contexts
kubectl config get-contexts

# get current context
kubectl config current-context

# set namespace for certain context
kubectl config set-context CONTEXT_NAME --namespace=NAMESPACE_NAME

# list pod with Namespace
kubectl get po --namespace=NAMESPACE_NAME

# connecting pods in same namespace
# via IP Address
kubectl describe po POD_2 # get POD_2 IP
kubectl exec -it POD_1 -- /bin/bash
# in POD_1 Terminal
curl POD_2_IP # Success

# connection pods in different namespace
# via CoreDNS
kubectl exec -it POD_1 --namespace=NAMESPACE_1 -- /bin/bash
# in POD_1 Terminal
# using Service
curl SERVICE_2.NAMESPACE_2
curl SERVICE_2.NAMESPACE_2.svc.CLUSTER_NAME
# using IP
curl POD_2_IP.NAMESPACE_2.pod.CLUSTER_NAME # IP 를 입력할 떄, "." 대신 "-" 로 바꾸어 입력해야한다