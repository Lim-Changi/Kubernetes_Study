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
#### Services
- 같은 역할의 Pod (= Load-Balanced) 에게 클러스터 IP 주소와 DNS 를 주고, 통신을 가능케 한다
- 서비스의 이름은 **같은 Namespace 안에서는 Unique** 해야한다

서비스의 종류
- NodePort
  - Node 당 하나씩 배정
  - Node 로 들어오는 외부 요청 처리
    - NodePort -> Service Port -> Target Port (Pod)
  - Default -> 30000 ~ 32767
- ClusterIP
  - 기본 Service 타입
  - Cluster 내부 요청 처리
  - ex) App ↔️ Cache, App ↔️ DB
- LoadBalancer
  - 하나의 서비스를 구성하는 각 Pod 에 Public IP 주소를 배정하고 외부 요청을 분산 처리
- Ingress
  - 대용량 요청 처리에 적합
  - 특정 조건을 설정하여 요청이 들어올 때, 특정 서비스에 조건이 맞는 요청을 보낼 수 있다
  - Proxy Controller
    - API Gateway 와 비슷

---
#### Namespace
- 여러 클러스터에 걸쳐있는 가상 Layer로 Resource, object 등을 나누기 위함
  - 부서 별로, 혹은 개발환경 별로 접근 가능한 자원들을 설정할 때 용이
  - AWS 자원을 구축할 때, Tag 와 비슷한 개념

> kubectl 명령어를 활용할때 따로 ```--namespace``` 옵션을 붙이지 않으면 default 로 처리된다

Namespace 특징
- Isolation
  - 각 Namespace 는 각자의 Resource 를 가질 수 있으며, 서로 관여해서는 안된다
- Resource Scoping
  - 다른 Namespace 에 있으면 같은 Name 을 가진 Resource 도 별개의 것으로 취급된다
- Security & Access Control
  - Role-Based Access Control (RBAC) 즉, 관리범위를 를 Namespace 단위로 설정할 수 있다 (= AWS IAM)
- Resource Quotas
  - Namespace 별로, 자원의 CPU, 메모리 등의 제한을 설정할 수 있다


#### DNS
같은 Namespace 안에서는 IP 나 서비스를 통해서 Pod 간 통신이 가능하지만, 
다른 Namespace 의 Pod 간 통신은 DNS 를 통해서만 통신이 가능하다


---
#### 명령어 사용 방식
- Imperative (명령형)
  - in Terminal using Command ```kubectl```
  - 빠르다
  - 디버깅 및 Troubleshooting 에 용이
- Declarative (선언적)
  - YAML, JSON
  - Infrastructure as Code (IaC) 
  - 구조적이고 자동화되어 있다
  - ex) Terraform, Ansible, Cloudformation

---
#### MSA
마이크로 서비스 아키텍처(Microservices Architecture)는 하나의 큰 애플리케이션을 작은 단위의 서비스로 분할하는 아키텍처 패턴입니다. 각 서비스는 독립적으로 개발, 배포, 운영될 수 있으며, 서로 다른 기술 스택과 데이터베이스를 사용할 수 있습니다

- MSA 의 장점
  - 유연성: 각 서비스는 독립적으로 개발, 배포, 운영될 수 있으므로 전체 시스템이 유연하게 확장될 수 있습니다.
  - 격리성: 각 서비스는 다른 서비스와 격리되어 있으므로, 오류가 발생해도 다른 서비스에 영향을 미치지 않습니다.
  - 재사용성: 각 서비스는 독립적으로 개발되어 재사용이 가능합니다.
  - 편리한 배포: 각 서비스는 독립적으로 배포될 수 있으므로, 전체 시스템의 배포가 더욱 편리합니다. 
  - 기술 다양성: 각 서비스는 독립적으로 개발되어 다른 기술 스택과 데이터베이스를 사용할 수 있습니다.
> 하지만, 마이크로 서비스 아키텍처를 구현하는 것은 단순한 작업이 아닙니다. 서비스 간 통신, 데이터 일관성 유지, 분산 트랜잭션 등 다양한 기술적 문제를 해결해야 합니다. 따라서, 마이크로 서비스 아키텍처를 구현하기 위해서는 적극적인 설계와 테스트, 모니터링 등의 작업이 필요합니다.

#### Deploying Local App with Minikube
1. Build a working app into an Docker image (+ DB if Necessary) 
2. Test Image with Docker-Compose in Local
3. Build & Push Image to your Docker Hub
4. Apply K8s Deployment script that works with your Image
5. Start App NodePort service with Minikube => ```minikube service SVC_NAME```
6. Check in Local with Minikube URL

---
#### Observability
쿠버네티스 클러스터 내에서 발생하는 이벤트와 상태를 모니터링하고 분석하는 프로세스를 말합니다. Observability는 애플리케이션 및 인프라스트럭처의 문제를 신속하게 탐지하고 해결하는 데 도움이 되며, 쿠버네티스 클러스터를 안정적으로 운영하는 데 중요한 역할을 합니다.  
=> HealthCheck
- Readiness probe
  - Check Container is Ready
  - if fails, removes container from endpoint
- Liveness probe
  - Check Container is Running
  - if fails, restarts the container

---
#### DaemonSet
- 각 Node Cluster 에 필수적으로 돌아가야하는 Process 를 설정해주는 Resource
  - Node 마다 하나씩 자동으로 생성되고 삭제
  - 시스템 단위의 작업들을 관리
    - Log Collector, Monitor Agent, Network Plugin..
  - Node 위주의 작업들을 구성할 때 용이

---
#### Cronjob
쿠버네티스에서 cronjob 은 정기적으로 실행되는 작업을 관리하기 위한 리소스입니다. cronjob 은 쿠버네티스 내부에서 crontab 파일과 유사한 방식으로 작동합니다. [[Crontab Schedule 참고]](https://crontab.guru)
- 일정한 간격으로 작업 실행
  - 지정된 스케줄에 따라 일정한 간격으로 작업을 실행
  - 주기적으로 실행되어야 하는 작업을 관리
- 작업의 병렬 처리
  - 여러 개의 파드(Pod)를 생성하여 작업을 병렬 처리  
  - 이를 통해 대규모 작업을 빠르게 처리 가능
- 실패한 작업의 재시도
  - 지정된 재시도 횟수 및 간격에 따라 작업이 실패하면 자동으로 재시도




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
 
