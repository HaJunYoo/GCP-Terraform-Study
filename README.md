# GCP-Terraform-Study

이 프로젝트는 환경별로 분리된 GCP 리소스를 Terraform으로 관리하기 위한 모듈화된 구조입니다.

## 구조

```
terraform/
├── envs/
│   └── dev/                          # 개발 환경
│       ├── main.tf                   # 백엔드 설정
│       ├── projects.tf               # GCP 프로젝트 생성
│       ├── network.tf                # VPC 및 네트워킹
│       ├── gke.tf                    # GKE 클러스터
│       ├── legacy.tf                 # 기존 리소스
│       ├── variables.tf              # 환경 변수
│       ├── outputs.tf                # 환경 출력
│       ├── terraform.tfvars          # 실제 설정값 (보안)
│       └── terraform.tfvars.example  # 예시 파일
├── modules/
│   ├── project/                      # GCP 프로젝트 모듈
│   ├── network/                      # VPC, 서브넷 모듈
│   ├── gke/                          # GKE 클러스터 모듈
│   ├── storage_legacy/               # 레거시 스토리지 모듈
│   └── compute_legacy/               # 레거시 컴퓨트 모듈
├── main.tf                           # 루트 프로바이더 설정
├── .pre-commit-config.yaml           # 코드 품질 관리
└── .gitignore                        # 보안 파일 제외
```

## 설정

### 1. 초기 설정

```bash
# 개발 환경으로 이동
cd envs/dev

# 설정 파일 생성 (보안 주의!)
cp terraform.tfvars.example terraform.tfvars

# ⚠️ IMPORTANT: terraform.tfvars에 실제 값 입력
# - billing_account_id: 실제 빌링 계정 ID
# - project_id: 기존 프로젝트 ID
# - 기타 실제 리소스 이름들
```

### 2. Pre-commit 훅 설정

```bash
# 루트 디렉토리로 이동
cd ../../

# pre-commit 설치
pip install pre-commit
# 또는 brew install pre-commit (macOS)

# pre-commit 훅 설치
pre-commit install
```

### 3. Terraform 초기화 및 배포

```bash
# 개발 환경으로 이동
cd envs/dev

# Terraform 초기화
terraform init

# 실행 계획 확인 (2개의 새 프로젝트 + VPC + GKE + 레거시 리소스)
terraform plan

# 리소스 배포
terraform apply
```

## Pre-commit 훅

이 프로젝트는 다음 pre-commit 훅을 사용합니다:

### Terraform 관련 훅
- **terraform-fmt**: 코드 포맷팅 (`terraform fmt -recursive`)
- **terraform-validate**: 구문 검증 (`terraform validate`)

### 일반적인 훅
- **trailing-whitespace**: 불필요한 공백 제거
- **end-of-file-fixer**: 파일 끝 줄바꿈 추가
- **check-yaml**: YAML 파일 구문 검사
- **check-added-large-files**: 대용량 파일 체크

### 수동 실행

```bash
# 모든 파일에 대해 pre-commit 실행
pre-commit run --all-files

# Terraform 포맷팅만 실행
terraform fmt -recursive

# Terraform 검증만 실행
terraform validate
```

## 환경별 리소스

### 개발 환경 (envs/dev/)
- **네트워크 프로젝트**: `hj-network-hub-dev` - Shared VPC 관리
- **인프라 프로젝트**: `hj-infra-dev` - GKE 클러스터 호스팅
- **레거시 프로젝트**: 기존 프로젝트의 스토리지 + 컴퓨트 리소스

### 백엔드 설정
- **버킷**: `hj-gcp-terraform-bucket`
- **리전**: Seoul (`asia-northeast3`)
- **상태 파일**: `terraform/envs/dev` prefix 사용

## 보안 가이드

### ⚠️ 중요한 보안 사항
- `terraform.tfvars` 파일은 **절대 Git에 커밋하지 마세요**
- `.gitignore`에 `*.tfvars` 가 제외되어 있는지 확인하세요
- `terraform.tfvars.example`만 더미 값으로 유지하세요

### 새로운 환경 추가
```bash
# prod 환경 생성 예시
cp -r envs/dev envs/prod
cd envs/prod
# terraform.tfvars를 prod 환경에 맞게 수정
```

## 모듈 확장

새로운 GCP 리소스를 추가할 때:
1. `modules/` 디렉토리에 새 모듈 생성
2. 환경별 디렉토리 (`envs/dev/`)에 새 `.tf` 파일 추가
3. 단일 책임 원칙에 따라 파일 분리
