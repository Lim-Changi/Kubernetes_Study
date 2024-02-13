# MacOS

# kubectl
brew install kubectl

# minikube
brew install minikube

# base k8s set
minikube start

# get all k8s pods
kubectl get po -A

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

# kubectl alias to kube
alias kube=`kubectl`