# Email notification channels for budget alerts
resource "google_monitoring_notification_channel" "budget_emails" {
  for_each = toset(var.notification_emails)

  project      = module.network_project.project_id
  display_name = "Budget Alert - ${each.value}"
  type         = "email"

  labels = {
    email_address = each.value
  }

  user_labels = {
    purpose     = "budget-alerts"
    environment = var.environment
  }

  depends_on = [module.network_project]
}

# Billing Budget for Dev Environment
module "dev_budget" {
  source = "../../modules/billing"

  billing_account_id  = var.billing_account_id
  budget_display_name = "Dev Environment Budget"
  budget_amount       = var.budget_amount
  currency_code       = var.currency_code

  # Apply budget to dev projects
  projects = [
    module.network_project.project_id,
    module.infrastructure_project.project_id,
    var.base_project_id
  ]

  # Threshold rules for alerts
  threshold_rules = var.threshold_rules

  # Notification settings
  enable_all_updates_rule = var.enable_budget_notifications
  monitoring_notification_channels = concat(
    var.notification_channels,
    [for channel in google_monitoring_notification_channel.budget_emails : channel.id]
  )
  disable_default_iam_recipients = false

  depends_on = [module.network_project, module.infrastructure_project, google_monitoring_notification_channel.budget_emails]
}
