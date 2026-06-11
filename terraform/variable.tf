# ----------------------------------------------------------------------------
# variable.tf — deployment in one place.
# Changing a value here changes the whole config without editing main.tf.
# Each variable has a default.
# ----------------------------------------------------------------------------

variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type (Minecraft needs ~4 GB RAM)"
  type        = string
  default     = "t2.medium"
}

variable "minecraft_port" {
  description = "TCP port the Minecraft server listens on"
  type        = number
  default     = 25565
}

variable "project_name" {
  description = "Name prefix for tagging resources"
  type        = string
  default     = "minecraft-p2"
}