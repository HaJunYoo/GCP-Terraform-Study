# Billing configuration
variable "billing_account_id" {
  type        = string
  description = "Billing account ID (format: 0123AB-4567CD-8901EF)"
}


variable "base_project_id" {
  type        = string
  description = "Base project ID"
}

# Environment configuration
variable "environment" {
  type        = string
  description = "Environment name"
  default     = "dev"
}

# Network configuration
variable "vpc_auto_create_subnets" {
  type        = bool
  description = "VPC에서 자동으로 서브넷을 생성할지 여부"
  default     = false
}

variable "vpc_mtu" {
  type        = number
  description = "VPC의 Maximum Transmission Unit (MTU)"
  default     = 1460
}

variable "gcp_region" {
  type        = string
  description = "GCP 리전"
  default     = "asia-northeast3"
}

variable "subnet_ip_range" {
  type        = list(string)
  description = "서브넷 IP 범위 리스트"
  default     = ["10.1.0.0/24"]
}
