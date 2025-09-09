# Billing Budget
resource "google_billing_budget" "budget" {
  billing_account = var.billing_account_id
  display_name    = var.budget_display_name

  budget_filter {
    # Apply budget to specific projects
    dynamic "projects" {
      for_each = var.projects
      content {
        name = "projects/${projects.value}"
      }
    }

    # Apply budget to specific services (optional)
    dynamic "services" {
      for_each = var.services
      content {
        name = services.value
      }
    }

    # Credit types to include/exclude
    credit_types_treatment = var.credit_types_treatment
  }

  amount {
    specified_amount {
      currency_code = var.currency_code
      units         = var.budget_amount
    }
  }

  # Threshold rules for alerts
  dynamic "threshold_rules" {
    for_each = var.threshold_rules
    content {
      threshold_percent = threshold_rules.value.threshold_percent
      spend_basis       = threshold_rules.value.spend_basis
    }
  }

  # All updates rule (optional)
  dynamic "all_updates_rule" {
    for_each = var.enable_all_updates_rule ? [1] : []
    content {
      # Pub/Sub topic for notifications
      pubsub_topic                     = var.pubsub_topic
      schema_version                   = var.schema_version
      monitoring_notification_channels = var.monitoring_notification_channels
      disable_default_iam_recipients   = var.disable_default_iam_recipients
    }
  }
}
