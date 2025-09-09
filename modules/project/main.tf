resource "google_project" "project" {
  name            = var.project_name
  project_id      = var.project_id
  billing_account = var.billing_account_id

  labels = merge(
    {
      environment = var.environment
      managed-by  = "terraform"
    },
    var.labels
  )
}

# Enable necessary APIs
resource "google_project_service" "apis" {
  for_each = toset(var.apis)

  project = google_project.project.project_id
  service = each.value

  disable_dependent_services = true
}
