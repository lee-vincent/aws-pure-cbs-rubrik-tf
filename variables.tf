# to deprovisoin Pure CBS 
#  1. remove deletion protection from cloudformation
#  2. pure cli: purearray factory-reset-token create
#  3. pure cli: purearray erase --factory-reset-token <token> --eradicate-all-data
#     wait about 20 minutes for the cloudformation template to delete all resources
#  4. set pure_cbs_prevent_destroy = false
#  5. run 'terraform destroy'
variable "pure_cbs_prevent_destroy" {
  description = "Prevents a successful 'terraform destroy' on Pure Cloud Block Store instances"
  type = bool
  default = true
}

variable "aws_bastion_instance_type" {
  type = string
}
variable "bilh_aws_demo_master_key_name" {
  type = string
}
variable "bilh_aws_demo_master_key_pub" {
  type      = string
  sensitive = true
}
variable "aws_windows_key_name" {
  type = string
}
variable "aws_windows_key_pub" {
  type      = string
  sensitive = true
}
variable "aws_profile" {
  type        = string
  description = "AWS profile."
}
variable "windows_ami" {
  default = "ami-033594f8862b03bb2"
}
variable "bilh_aws_demo_master_key" {
  type      = string
  sensitive = false
}
variable "aws_region" {
  type = string
}
variable "aws_zone" {
  type = string
}
variable "aws_prefix" {
  type = string
}
variable "template_url" {
  type = string
}
variable "log_sender_domain" {
  type = string
}
variable "alert_recipients" {
  type = list(string)
}
variable "purity_instance_type" {
  type = string
}
variable "license_key" {
  type = string
}