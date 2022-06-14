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
variable "aws_profile" {
  type        = string
  description = "AWS profile."
}
variable "bilh_aws_demo_master_key" {
  type = string
}


variable "rubrik_user" {
  type    = string
  default = "admin"
}
variable "rubrik_pass" {
  type = string
}
variable "rubrik_fileset_name_prefix" {
  type    = string
  default = "EPIC"
}
variable "rubrik_fileset_folder_path" {
  type    = string
  default = "/mnt/epic-iscsi-vol"
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