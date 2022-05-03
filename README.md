# Kubernetes_Study 
### 인프런 - 대세는 쿠버네티스
---
#### 등장 배경

> 기존의 VM 가상화 기술
> - 서비스 보다 무거운 OS 를 띄워야 함

> **Docker**
> - 리눅스의 복잡한 자원 격리 기술을 Container 라는 개념으로 누구나 쉽게 사용할 수 있게 만들어줌
> - 컨테이너 가상화 기술
> -> OS 를 안띄워도 돼서, 자동화시 매우 빠르고 자원 효율성도 높음
> * 단, 도커 자체는 하나의 서비시를 컨테이너로 가상화 시켜서 배포할뿐, 여러 서비스들을 운영할때, 일일이 배포하고 운영해주는 역할을 하지 않음
>> `Container Orchestrator` -> 여러 컨테이너들을 관리해주는 솔루션
> 가장 대표적인 것이 **Kubernetes**

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
 

---
#### VM vs Container
컨테이너 서비스에서는 개발 환경을 일정하게 유지할 수 있다
컨테이너서비스는 새로운 서비스를 활용하기 위해 OS를 띄울필요가 없다.
보안적인 측면에서는 컨테이너 하나가 뚤려서 OS에 접근이 가능해지면 다른 컨테이너들도 위험해질 수 있다.
VM -> 여러 OS 가 Host OS에 개별적으로 연결
Container -> 공통의 OS 를 여러 서비스 Container가 활용

**MSA**
각 모듈에 맞는 가장 효율적인 언어로 서비스를 개발하여 개별 서비스를 컨테이너로 나누어서 한 `Pod` 에 담고,
부하가 많이가는 모듈의 Pod 을 여러 개 띄울 수 있다.
-> 쿠버네티스가 해당 프로세스를 간단하게 만들어준다.