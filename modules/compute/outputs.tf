output "instance_names" {
  description = "Names of the created compute instances"
  value       = [for instance in google_compute_instance.instances : instance.name]
}

output "instance_zones" {
  description = "Zones of the created compute instances"
  value       = [for instance in google_compute_instance.instances : instance.zone]
}

output "instance_internal_ips" {
  description = "Internal IP addresses of the created compute instances"
  value       = [for instance in google_compute_instance.instances : instance.network_interface[0].network_ip]
}

output "instance_external_ips" {
  description = "External IP addresses of the created compute instances"
  value = [for instance in google_compute_instance.instances :
    length(instance.network_interface[0].access_config) > 0 ?
    instance.network_interface[0].access_config[0].nat_ip : null
  ]
}

output "instance_self_links" {
  description = "Self-links of the created compute instances"
  value       = [for instance in google_compute_instance.instances : instance.self_link]
}
