output "budget_name" {
  description = "The name of the created budget"
  value       = google_billing_budget.budget.name
}

output "budget_display_name" {
  description = "The display name of the budget"
  value       = google_billing_budget.budget.display_name
}

output "budget_amount" {
  description = "The budget amount"
  value       = google_billing_budget.budget.amount[0].specified_amount[0].units
}

output "currency_code" {
  description = "The currency code"
  value       = google_billing_budget.budget.amount[0].specified_amount[0].currency_code
}
