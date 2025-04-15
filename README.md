# Sample
Terraform을 사용해 AWS EKS와 VPC를 구성하고, Spring Boot 컨테이너를 AWS Load Balancer Controller(ALB Ingress)를 통해 인터넷에 공개하는 샘플 프로젝트입니다.

# 아키텍처 구성
## VPC (Network) 구성
- terraform 공식 [vpc](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest) 모듈 사용
- VPC CIDR: 10.21.0.0/16
- Public Subnet: 10.21.0.0/24, 10.21.1.0/24
  - ALB(ingress), NAT Gateway 배치
- Private Subnet: 10.21.32.0/24, 10.21.33.0/24
  - 동일 AZ의 Public Subnet에 배치된 NAT Gateway를 통해 인터넷 통신

## Kubernetes (EKS) 구성
- terraform 공식 [eks](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest) 모듈 사용
- [EKS Blueprints Addons](https://registry.terraform.io/modules/aws-ia/eks-blueprints-addons/aws/latest) 모듈 사용
- Spring Boot 애플리케이션은 Private Subnet의 노드(Pod Affinity)에 배치
- Internet-facing ALB를 통한 트래픽 라우팅

## Application (Springboot, Docker) 구성
- [Spring Boot Application](https://spring.io/guides/gs/spring-boot-docker)
  - Spring Boot 3.4.4
  - Gradle (Groovy)
  - Java
  - Docker

# 프로젝트 배포
## 인프라 배포
```bash
# terraform 
cd terrafrom

# Terraform 초기화
terraform init

# 배포 계획 검토
terraform plan

# 인프라 배포
terraform apply
```

## 애플리케이션 배포
``` bash
# Springboot 빌드
./gradlew clean build

# Docker 이미지 빌드
docker build -t springboot-app .

# 컨테이너 레지스트리 업로드
docker push [레지스트리 주소]/springboot-app

# Kubernetes 배포
kubectl apply -f k8s/
```

## 리소스 정리
``` bash
kubectl delete -f k8s/
terraform destroy
```