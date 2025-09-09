# Project outputs
output "network_project_id" {
  description = "Network project ID"
  value       = module.network_project.project_id
}

output "network_project_number" {
  description = "Network project number"
  value       = module.network_project.project_number
}

output "infrastructure_project_id" {
  description = "Infrastructure project ID"
  value       = module.infrastructure_project.project_id
}

output "infrastructure_project_number" {
  description = "Infrastructure project number"
  value       = module.infrastructure_project.project_number
}

# Billing outputs
output "budget_name" {
  description = "Budget name"
  value       = module.dev_budget.budget_name
}

output "budget_display_name" {
  description = "Budget display name"
  value       = module.dev_budget.budget_display_name
}

output "budget_amount" {
  description = "Budget amount"
  value       = "${module.dev_budget.budget_amount} ${module.dev_budget.currency_code}"
}
