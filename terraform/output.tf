# ----------------------------------------------------------------------------
# output.tf — The values Terraform prints after `apply` (and on demand with
# `terraform output`). Used by deploy.sh to grab the IP, and to
# copy the verification command.
# ----------------------------------------------------------------------------


output "instance_public_ip" {
  description = "Public IP of the Minecraft server"
  value       = aws_instance.minecraft.public_ip
}

output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.minecraft.id
}

output "nmap_check" {
  description = "Verify the Minecraft server"
  value       = "nmap -sV -Pn -p T:${var.minecraft_port} ${aws_instance.minecraft.public_ip}"
}