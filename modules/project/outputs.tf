output "project_id" {
  description = "The project ID"
  value       = google_project.project.project_id
}

output "project_number" {
  description = "The project number"
  value       = google_project.project.number
}

output "project_name" {
  description = "The project name"
  value       = google_project.project.name
}
