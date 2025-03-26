output "load_balancer_dns" {
  description = "DNS name of the load balancer"
  value       = module.loadbalancer.dns_name
}

output "service_urls" {
  description = "Map of service names to their public URLs"
  value = {
    for service_name, service_config in module.services.services :
    service_name => "https://${module.loadbalancer.dns_name}/${service_name}"
  }
}
