# Outputs for Pre-Requisites
output "bastion_instance_private_ip" {
  value = aws_instance.bastion_instance.private_ip
}
output "bastion_instance_public_ip" {
  value = aws_instance.bastion_instance.public_ip
}
output "bastion_instance_name" {
  value = aws_instance.bastion_instance.tags["Name"]
}

# rubrik s3 bucket name
# rubrik node private ip

output "rubrik_ips" {
  value = module.rubrik-cloud-cluster.rubrik_cloud_cluster_ip_addrs[*]
}


#Outputs for CBS
# output "cbs_gui_endpoint" {
#   value = cbs_array_aws.cbs_aws.gui_endpoint
# }
# output "cbs_repl_endpoint_ct0" {
#   value = cbs_array_aws.cbs_aws.replication_endpoint_ct0
# }
# output "cbs_floating_mgmt_ip" {
#   value = cbs_array_aws.cbs_aws.management_endpoint
# }
# output "cbs_repl_endpoint_ct1" {
#   value = cbs_array_aws.cbs_aws.replication_endpoint_ct1
# }
# output "cbs_iscsi_endpoint_ct0" {
#   value = cbs_array_aws.cbs_aws.iscsi_endpoint_ct0
# }
# output "cbs_iscsi_endpoint_ct1" {
#   value = cbs_array_aws.cbs_aws.iscsi_endpoint_ct1
# }

#Outputs for linux workload instance (iscsi initiator)
# output "public_dns" {
#   value = aws_instance.linux_iscsi_workload.*.public_dns
# }
# output "public_ip" {
#   value = aws_instance.linux_iscsi_workload.*.public_ip
# }
# output "name" {
#   value = aws_instance.linux_iscsi_workload.*.tags.Name
# }