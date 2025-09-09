resource "google_compute_instance" "instances" {
  for_each = var.instances

  name         = each.value.name
  machine_type = each.value.machine_type
  zone         = each.value.zone

  boot_disk {
    initialize_params {
      image = each.value.image
      size  = each.value.disk_size
    }
  }

  network_interface {
    network    = each.value.network
    subnetwork = each.value.subnetwork

    dynamic "access_config" {
      for_each = each.value.enable_public_ip ? [1] : []
      content {
        // Ephemeral public IP
      }
    }
  }

  tags = each.value.tags

  labels = merge(
    {
      environment = var.environment
      managed-by  = "terraform"
    },
    each.value.labels
  )

  metadata = each.value.metadata

  service_account {
    email  = each.value.service_account_email
    scopes = each.value.service_account_scopes
  }
}
