# GCP-Terraform-Study

이 프로젝트는 GCP 리소스를 Terraform으로 관리하기 위한 모듈화된 구조입니다.

## 구조

```
.
├── main.tf                    # 메인 Terraform 설정
├── variables.tf              # 전역 변수
├── outputs.tf                # 전역 출력
├── terraform.tfvars.example  # 변수 값 예시
├── .pre-commit-config.yaml   # pre-commit 설정
└── modules/                  # 모듈 디렉토리
    ├── storage/              # Cloud Storage 모듈
    ├── compute/              # Compute Engine 모듈
    ├── networking/           # VPC, 네트워킹 모듈
    ├── database/             # Cloud SQL 모듈
    └── kubernetes/           # GKE 모듈
```

## 설정

### 1. 초기 설정

```bash
# terraform.tfvars 파일 생성
cp terraform.tfvars.example terraform.tfvars
# 프로젝트 ID 등 값 수정
```

### 2. Pre-commit 훅 설정

```bash
# pre-commit 설치
pip install pre-commit

# 또는 brew로 설치 (macOS)
brew install pre-commit

# pre-commit 훅 설치
pre-commit install
```

### 3. Terraform 초기화 및 배포

```bash
# Terraform 초기화
terraform init

# 실행 계획 확인
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

## 백엔드 설정

- **버킷**: `gcp bucket`
- **리전**: Seoul (`asia-northeast3`)
- **상태 파일**: `terraform/state` prefix 사용

## 모듈 추가

새로운 GCP 리소스를 추가할 때는 `modules/` 디렉토리에 새 모듈을 생성하고 `main.tf`에서 호출하세요.
