# Outputs for Pre-Requisites
output "linux_mgmt_instance_private_ip" {
  value = aws_instance.linux_mgmt_instance.private_ip
}
output "linux_mgmt_instance_public_ip" {
  value = aws_instance.linux_mgmt_instance.public_ip
}
output "linux_mgmt_instance_name" {
  value = aws_instance.linux_mgmt_instance.tags["Name"]
}
#Outputs for CBS
output "cbs_gui_endpoint" {
  value = cbs_array_aws.cbs_aws.gui_endpoint
}
output "cbs_repl_endpoint_ct0" {
  value = cbs_array_aws.cbs_aws.replication_endpoint_ct0
}
output "cbs_floating_mgmt_ip" {
  value = cbs_array_aws.cbs_aws.management_endpoint
}
output "cbs_repl_endpoint_ct1" {
  value = cbs_array_aws.cbs_aws.replication_endpoint_ct1
}
output "cbs_iscsi_endpoint_ct0" {
  value = cbs_array_aws.cbs_aws.iscsi_endpoint_ct0
}
output "cbs_iscsi_endpoint_ct1" {
  value = cbs_array_aws.cbs_aws.iscsi_endpoint_ct1
}

#Outputs for linux workload instance (iscsi initiator)
output "public_dns" {
  value = aws_instance.linux_iscsi_workload.*.public_dns
}
output "public_ip" {
  value = aws_instance.linux_iscsi_workload.*.public_ip
}
output "name" {
  value = aws_instance.linux_iscsi_workload.*.tags.Name
}