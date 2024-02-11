# Kubernetes 스터디 

---
#### 등장 배경

> 기존의 Virtual Machine 가상화 기술
> - 각 서비스 별 VS OS 가 필요
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
 
