# Kubernetes 스터디 

---
#### 등장 배경

> 기존의 Virtual Machine 가상화 기술
> - 각 서비스 별 VM OS 가 필요
> - 서비스 보다 무거운 OS 를 띄워야 함

> **Docker**
> - 리눅스의 복잡한 자원 격리 기술을 Container 라는 개념으로 누구나 쉽게 사용할 수 있게 만들어줌
> - 컨테이너 가상화 기술
> -> OS 를 안띄워도 돼서, 자동화시 매우 빠르고 자원 효율성도 높음
> 단, 도커 자체는 하나의 서비스를 컨테이너로 가상화 시켜서 배포할뿐, 여러 서비스들을 운영할때, 일일이 배포하고 운영해주는 역할을 하지 않음

> `Container Orchestrator` -> 여러 컨테이너들을 관리해주는 솔루션 
>> 가장 대표적인 것이 **Kubernetes** 
>> 이외에 Docker Swarm 등이 있음

--- 
#### VM vs Container
VM -> 여러 OS 가 Host OS에 개별적으로 연결
Container -> 공통의 OS 를 여러 서비스 Container 가 활용

컨테이너 서비스에서는 개발 환경을 일정하게 유지 가능
단, 보안적인 측면에서는 컨테이너 하나가 뚤려서 OS에 접근이 가능해지면 다른 컨테이너들도 위험해질 수 있다


---
#### Pod
쿠버네티스에서 컨테이너는 파드(pod)라는 단위로 관리된다

Pod는 하나 이상의 컨테이너를 포함하며, 같은 노드에서 실행되는 컨테이너들을 묶어서 관리한다

쿠버네티스에서 애플리케이션은 디플로이먼트(deployment)라는 객체로 정의되며, 디플로이먼트는 파드(Pod)를 생성하고 관리하는데 사용되며, 롤링 업데이트(rolling update)와 롤백(rollback)을 지원한다

---
#### Control Plane
- kube API Server : Node Access 관리
- etcd : Key, Value Storage (.env 역할)
- kube scheduler : Pod 배포 관리
- ...
#### Node
- kublet : Pod status check
- kube-proxy : kube network 관리
- ...

![img](https://kubernetes.io/images/docs/components-of-kubernetes.svg) 
_[출처: Kubernetes 공식 문서]_


---
#### K8s 장점
서비스에 부하가 있을 때, Container Level 에서 같은 서비스(Pod)를 생성하고 Load Balancing 을 하는 과정,
즉 Auto Scaling 과정이 기존보다 빠르게 처리가 가능하다

또한 Pod 뿐 아니라, 이를 담고 있는 Node 를 추가하는 것도 가능   

---
#### MSA 환경에서 K8s 의 장점 
각 모듈에 맞는 가장 효율적인 언어로 서비스를 개발하고 개별 서비스 별 컨테이너를 나누어서 한 `Pod` 에 담고,
부하가 많이가는 모듈의 Pod 을 여러 개 배치
-> 쿠버네티스가 해당 프로세스를 간단하게 만들어준다.


---
#### kubectl
쿠버네티스 클러스터를 커맨드를 통해 컨트롤하는 툴 (kubernetes cli)

#### minikube
로컬에 쿠버네티스를 돌리게 해주는 툴



---
#### etcd
- Key-Value Pair 를 보관 
  - Critical, Stateful Data => 인증정보 등,,
- 데이터가 변경 될 때 Notification 및 백업 복구등의 기능 제공
- https://etcd.io
- https://github.com/etcd-io/etcd/releases
  - run local etcd server
- 키페어 저장 및 조회
  - docker exec ~~/etcdctl put key val
  - docker exec ~~/etcdctl get key
- **Update to Desired State**



---
### K8s API Server
중앙 요청 관리자
- etcd 에 접근하기 위해서는 항상 K8s API Server 를 통해서만 가능
- etcd 에서 Desired Status 변경 감지 후, 전달 역할


### K8s Scheduler
API Server 를 통해 Desired State 의 변경을 전달 받은 후, Pod 을 어떤 Node 에 배치할지 선택하는 역할
- cpu 가 가장 많이 남는 Node 선택

### Kubelet
Worker Node 관리자
- Node Register
- Pod Creation
- Monitor node, pod

### Pod
- K8s 에서 배포 가능한 가장 작은 단위
  - 즉, Scaling 이 가능한 최소 단위
- 하나 이상의 컨테이너를 담을 수 있다
  - 하지만, 밀접하게 연관되어 있는 컨테이너가 아니면 같은 Pod 에 담으면 안된다
  - 같은 네트워크와 저장공간을 공유
- Scale Out
  - 같은 Node 안에 동일한 서비스 Deployment 를 담은 Pod 를 추가한다
  - 추후, Load Balancing 을 통해 요청 분산

---
#### Docker CMD & ENTRYPOINT
- CMD
  - 가장 마지막 커맨드만 실행된다 -> 이전의 커맨드는 Ignore
- ENTRYPOINT
  - 명령어에 추가로 Appending 이 가능
- Using Both
  - ENTRYPOINT 에 이어 CMD 가 Append 되어 실행

- Docker 파일에 ENTRYPOINT, CMD 가 정의되어 있어도 실행 시, 
커맨드 라인에서 --entrypoint 옵션을 통해 작성된 값을 Override 할 수 있다. 

- K8s Configuration file (.yml)
  - command == ENTRYPOINT
  - args == CMD
  - 위의 값을 설정하면, 기존 DockerFile 의 ENTRYPOINT 와 CMD 를 무시(Override)하고 설정한 값으로 실행한다.


---
#### K8s Image Pulling
- K8s 기본세팅에선 Pod Container 이미지를 지정해도, **Docker Hub**에서 Image 를 받아오려 하고, local Docker image를 받지 않는다
- 이에 따라 설정을 변경 해주어야 함
  - ```eval $(minikube docker-env)```
    - 해당 라인을 통해 Local 터미널에서 K8s Cluster 를 컨트롤 하도록 변경한다
    - 후에 docker Image 를 build 하면, K8s YAML 파일에서 Image 를 정상적으로 읽어올 수 있다
    - 그래도 안된다면, 아래 YAML 파일에 라인을 추가한다
  - ```imagePullPolicy: IfNotPresent```

- K8s 공식문서
  - Note:
    You should avoid using the :latest tag when deploying containers in production as it is harder to track which version of the image is running and more difficult to roll back properly.
  - 즉, latest 태그를 쓰지말라는 얘기다.

---
#### Label & Selector
둘 모두 K8s 구성요소를 Identifying 및 Grouping 하기 위함
- Label
  - K-V Pair 을 Resource 에 넣을 수 있음
- Selector
  - Label 의 K-V Pair 을 활용하여 특정 Resource 를 Filter 및 Select

#### Annotation
label 과 같은 형태로 Resource 에 넣어줄 수 있지만, 
이름 그대로 주석의 의미로 해당 Resource 를 설명하는 데에만 쓰이고, 조회되거나 선택의 기준이 되는데에는 활용되지 않는다

---
#### Controller
- 시스템 감시자
  - 시스템의 state 을 전체 관리한다.
  - 예) Pod replica 개수 유지
- 종류
  - Replication Controller
    - == Replica Set
    - RC 는 Deprecated 되어 더이상 사용되지 않음. use ReplicaSet
  - Deployment Controller
  - StatefulSet Controller
  - DaemonSet Controller
  - Job Controller

---
#### Deployment
Deployment 는 ReplicaSet 을 관리하며, 다른 유용한 기능과 함께 Pod 에 대한 선언적 업데이트를 제공하는 상위 개념.
ReplicaSet 과 비슷하지만, 구성하는 Pod 을 Update 할 때 용이하다는 장점이 있다

Deployment > ReplicaSet > Pod  

> 즉, 굳이 ReplicaSet & Pod 종류의 오브젝트 yaml 파일을 작성 하기보다는 
> 하위로 ReplicaSet & Pod 내용을 모두 포함하는 Deployment 오브젝트 yaml 파일만 작성하면된다.

- Deployment Strategy
  - in YAML spec, ```strategy: type: "Recreate"```
  - RollingUpdate = default
  - Recreate
  - Blue/Green 
  - Canary 
  - A/B 
  - etc...

- [K8s 공식문서](https://kubernetes.io/ko/docs/concepts/workloads/controllers/deployment/#%EB%94%94%ED%94%8C%EB%A1%9C%EC%9D%B4%EB%A8%BC%ED%8A%B8-%EC%83%9D%EC%84%B1)

---
#### Kube Proxy
- 각각의 Node 안에서 IP Table 을 만든다
- 서비스 IP 주소를 Pod 에 맵핑한다
- Load Balancing
- Node Port Service
- Health Check

> Nginx, ELB 와 비슷한 역할

---
#### Cluster Network
- Pod 간 통신?
  - 모든 Pod 은 Unique IP Address 가 있어야함
    - Pod 간 통신이 가능해야함
    - IP Address (= NAT) 를 통해 통신 X
  - **CNI (Container Network Interface) Plugin** 을 활용하여 통신!
    - Pod 가 통신할 수 있는 Routing Table 을 제공
    - ex) Calico, Flannel, Weave Net
    - kublet 에서 Pod 를 만들 떄, CNI 에 요청을 보내 Routing Table 을 만든다 


---


#### 쿠버네티스 User
* Workloads
  * Pod
  * Replication Controller
  * ReplicaSet
  * StatefulSet
  * Deployment
  * DaemonSet
  * Job
  * CronJob
* Service 
  * Service
  * Endpoints
  * Ingress
* Storage/Config 
  * PV
  * PVC
  * ConfigMap
  * Secret
  * StorageClass
  * Volume
* Metadata
  * LimitRange
  * CRD
  * Event
  * HPA
  * MWC / VWC
  * PriorityClass
  * PodTemplate
  * PodDisruption Budget
  * PodPreset
  * PodSecurity Policy 
* Cluster
  * Namespace
  * ResourceQuota
  * Node
  * Role / RoleBinding
  * Policy
  * ServiceAccount
  * NodeScheduling
 
