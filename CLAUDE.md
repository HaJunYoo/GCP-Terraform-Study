# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is an environment-based modular Terraform project for managing GCP infrastructure with Seoul region (`asia-northeast3`) as the default. The architecture follows Terraform best practices with reusable modules, centralized state management, and environment separation.

### Directory Structure
```
terraform/
├── envs/
│   └── dev/                    # Development environment
│       ├── main.tf             # Backend configuration only
│       ├── projects.tf         # GCP project creation & APIs
│       ├── network.tf          # VPC, subnets, firewall rules
│       ├── gke.tf              # GKE cluster and node pools
│       ├── legacy.tf           # Legacy storage & compute resources
│       ├── variables.tf        # Environment-specific variables
│       ├── outputs.tf          # Environment-specific outputs
│       ├── terraform.tfvars    # ⚠️ ACTUAL VALUES (never commit!)
│       └── terraform.tfvars.example # Safe dummy values only
├── modules/
│   ├── project/                # GCP project creation module
│   ├── network/                # VPC and subnet module
│   ├── gke/                    # GKE cluster module
│   ├── storage_legacy/         # Legacy storage module
│   └── compute_legacy/         # Legacy compute module
└── main.tf                     # Root provider configuration
```

### Environment-based Projects (Dev)
- **Legacy Project**: `lustrous-acumen-466815-g8` - Existing compute and storage resources
- **Network Project**: `hj-network-hub-dev` - Dedicated VPC and networking resources
- **Infrastructure Project**: `hj-infra-dev` - GKE cluster and application resources

### Core Benefits
- **Environment Isolation**: Each environment in separate directory with own state
- **Single Responsibility**: Each .tf file handles one specific concern
- **Module Reusability**: Common modules shared across environments
- **Project Separation**: Network, compute, and application resources in separate projects
- **Security by Design**: Sensitive files properly excluded from version control
- **Access Control**: Different IAM policies per project type
- **Billing Separation**: Separate billing tracking per project and environment

### File Responsibility Pattern (SRP)
- **main.tf**: Backend configuration and state management only
- **projects.tf**: GCP project creation, APIs, and project-level settings
- **network.tf**: VPC, subnets, firewall rules, and network security
- **gke.tf**: GKE clusters, node pools, and Kubernetes configuration
- **legacy.tf**: Existing storage and compute resources (backward compatibility)
- **variables.tf**: All input variables and their documentation
- **outputs.tf**: All outputs and their descriptions

### Module Design Patterns
- **Project Module**: Manages GCP projects with APIs and billing
- **Network Module**: Uses `for_each` for multiple subnets with secondary ranges
- **GKE Module**: Comprehensive cluster management with node pools and security
- **Legacy Modules**: Backward compatibility with existing storage/compute resources
- **Consistent Labeling**: All resources tagged with `environment` and `managed-by` labels

## Security Guidelines

### ⚠️ Critical Security Rules
**NEVER commit sensitive files to version control:**
- `terraform.tfvars` contains real credentials and project IDs
- `*.tfstate*` files contain infrastructure secrets
- `.terraform/` directories contain provider credentials

### Safe Configuration Pattern
1. **terraform.tfvars.example**: Contains only dummy/placeholder values
   - Use placeholder values like `ABCDEF-123456-789012`
   - Include security warnings in comments
   - Safe to share and commit to Git

2. **terraform.tfvars**: Contains actual production values
   - Real billing account IDs and project IDs
   - Actual resource names and sensitive configuration
   - **MUST be excluded from Git** (via .gitignore)

### Security Validation
```bash
# Verify sensitive files are ignored
git status --ignored

# Check .gitignore includes
grep -E "*.tfvars$|*.tfstate" .gitignore
```

## Essential Commands

### Initial Setup
```bash
# Navigate to dev environment
cd envs/dev

# Copy example configuration
cp terraform.tfvars.example terraform.tfvars

# IMPORTANT: Edit terraform.tfvars with your actual values:
# - billing_account_id: Your billing account ID (format: 0123AB-4567CD-8901EF)
# - project_id: Your existing project ID for legacy resources

# Install pre-commit hooks (from root directory)
cd ../../
pre-commit install
```

### Required Permissions
Before running terraform, ensure you have:
- **Project Creation**: Project Creator (`roles/resourcemanager.projectCreator`) in your current project or at account level
- **Billing**: Billing Account User (`roles/billing.user`) for the billing account
- **API Requirements**: Cloud Billing API must be enabled in your current project (`lustrous-acumen-466815-g8`)

### Terraform Operations (in envs/dev/)
```bash
# Navigate to dev environment
cd envs/dev

# Initialize (required after cloning or backend changes)
terraform init

# Plan changes (shows what will be created: 2 new projects + VPC + GKE + legacy resources)
terraform plan

# Apply changes
terraform apply

# Format all Terraform files (from root directory)
cd ../../
terraform fmt -recursive

# Validate configuration (from dev environment)
cd envs/dev
terraform validate
```

### Pre-commit Operations
```bash
# Run all pre-commit hooks
pre-commit run --all-files

# Run specific hooks
terraform fmt -recursive
terraform validate
```

## Configuration Management

### State Backend
- **Bucket**: `hj-gcp-terraform-bucket`
- **Region**: Seoul (`asia-northeast3`)
- **Path**: `terraform/state`
- **Note**: Backend bucket name is hardcoded in `main.tf` as variables are not supported in backend configuration

### Variable Configuration
- **terraform.tfvars**: Actual values (not committed to git)
- **terraform.tfvars.example**: Template with example configurations
- **variables.tf**: Variable definitions with types and descriptions

### Adding New Resources
When adding new GCP services:
1. **Create Module**: Add new module under `modules/` directory
   - Follow pattern: `main.tf`, `variables.tf`, `outputs.tf`
   - Include comprehensive variable documentation

2. **Create Environment File**: Add new `.tf` file in `envs/dev/`
   - Follow single responsibility principle
   - Name file after the service (e.g., `database.tf`, `monitoring.tf`)

3. **Update Configuration**:
   - Add new variables to `envs/dev/variables.tf`
   - Add new outputs to `envs/dev/outputs.tf`
   - Update `terraform.tfvars.example` with dummy values

### File Naming Conventions
- **modules/**: Service name (singular): `project`, `network`, `gke`
- **envs/dev/**: Functional name: `projects.tf`, `network.tf`, `gke.tf`
- **Variables**: Use underscore_case: `billing_account_id`, `project_id`

### Resource Naming Convention
- Use descriptive names with environment context (e.g., `hj-web-server-seoul`)
- Include region/zone information where relevant
- Use consistent tagging: environment, role, team labels

## Pre-commit Configuration
Automatically runs on commit:
- `terraform fmt -recursive`: Code formatting
- `terraform validate`: Syntax validation (with backend=false)
- File cleanups: trailing whitespace, end-of-file fixes
- YAML validation and large file detection
