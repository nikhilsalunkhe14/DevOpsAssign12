# In terraform/outputs.tf

output "swarm_nodes_public_ips" {
  description = "Public IPs of the Swarm nodes"
  value = {
    for k, v in aws_eip.eips : k => v.public_ip
  }
}