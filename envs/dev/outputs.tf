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
