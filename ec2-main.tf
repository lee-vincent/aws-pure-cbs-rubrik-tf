# provider "vault" {
#   address = "http://localhost:8200"
#   token   = "<unsealtokenfromvault>"
# }

# data "vault_generic_secret" "aws_auth" {
#   path = "secret/<keyname>"
# }

resource "aws_key_pair" "pure_cbs_key_pair" {
  key_name   = var.aws_key_name
  public_key = var.aws_public_key
}

resource "aws_instance" "linux_iscsi_workload" {
  # depends_on = [
  #   cbs_array_aws.cbs_aws,
  #   module.rubrik-cloud-cluster
  # ]
  ami                    = data.aws_ami.amazon_linux2.image_id
  instance_type          = "t3.large"
  vpc_security_group_ids = [aws_security_group.cbs_iscsi.id, aws_security_group.bastion.id]
  get_password_data      = false
  subnet_id              = aws_subnet.workload.id
  key_name               = var.aws_key_name
  tags = {
    Name = "iscsi_workload"
  }

    #   echo -e "\nexport PURE="${cbs_array_aws.cbs_aws.management_endpoint}"" >> /home/ec2-user/.bashrc
    # echo -e "\nexport RUBRIK="${module.rubrik-cloud-cluster.rubrik_cloud_cluster_ip_addrs[0]}"" >> /home/ec2-user/.bashrc
    # export PURE="${cbs_array_aws.cbs_aws.management_endpoint}"
    # export RUBRIK="${module.rubrik-cloud-cluster.rubrik_cloud_cluster_ip_addrs[0]}"
  user_data = <<-EOF1
    #!/bin/bash
    touch /home/ec2-user/.ssh/cbs-mgmt-key
    chown ec2-user:ec2-user /home/ec2-user/.ssh/cbs-mgmt-key
    echo "${var.cbs_mgmt_key}" > /home/ec2-user/.ssh/cbs-mgmt-key
    chmod 0400 /home/ec2-user/.ssh/cbs-mgmt-key

    mkdir /tmp/rbs
    cd /tmp/rbs
    wget --no-check-certificate https://$RUBRIK/connector/rubrik-agent.x86_64.rpm
    rpm -i rubrik-agent.x86_64.rpm
    yum update -y
    yum -y install iscsi-initiator-utils
    yum -y install lsscsi
    yum -y install device-mapper-multipath
    service iscsid start
    sed -i 's/^\(node\.session\.nr_sessions\s*=\s*\).*$/\132/' /etc/iscsi/iscsid.conf
    # only required with Amazon Linux 2 AMI
    rm -rf /etc/udev/rules.d/51-ec2-hvm-devices.rules
    cat <<EOF2>/etc/udev/rules.d/99-pure-storage.rules
    # Recommended settings for Pure Storage FlashArray.cat

    # Use noop scheduler for high-performance solid-state storage
    ACTION=="add|change", KERNEL=="sd*[!0-9]", SUBSYSTEM=="block", ENV{ID_VENDOR}=="PURE", ATTR{queue/scheduler}="noop"

    # Reduce CPU overhead due to entropy collection
    ACTION=="add|change", KERNEL=="sd*[!0-9]", SUBSYSTEM=="block", ENV{ID_VENDOR}=="PURE", ATTR{queue/add_random}="0"

    # Spread CPU load by redirecting completions to originating CPU
    ACTION=="add|change", KERNEL=="sd*[!0-9]", SUBSYSTEM=="block", ENV{ID_VENDOR}=="PURE", ATTR{queue/rq_affinity}="2"

    # Set the HBA timeout to 60 seconds
    ACTION=="add", SUBSYSTEMS=="scsi", ATTRS{model}=="FlashArray ", RUN+="/bin/sh -c 'echo 60 > /sys/$DEVPATH/device/timeout'"
    EOF2

    mpathconf --enable --with_multipathd y

    cat <<EOF3>/etc/multipath.conf
    defaults {
      polling_interval 10
      user_friendly_names yes
      find_multipaths yes
    }
    devices {
      device {
        vendor                "PURE"
        path_selector         "queue-length 0"
        path_grouping_policy  group_by_prio
        path_checker          tur
        fast_io_fail_tmo      10
        no_path_retry         queue
        hardware_handler      "1 alua"
        prio                  alua
        failback              immediate
      }
    }
    EOF3

    service multipathd restart
    amazon-linux-extras install epel -y
    #yum install sshpass -y
    iqn=`awk -F= '{ print $2 }' /etc/iscsi/initiatorname.iscsi`
    ssh -i /home/ec2-user/.ssh/cbs-mgmt-key -oStrictHostKeyChecking=no pureuser@"${cbs_array_aws.cbs_aws.management_endpoint}" purehost create linux-iscsi-host --iqnlist $iqn
    ssh -i /home/ec2-user/.ssh/cbs-mgmt-key -oStrictHostKeyChecking=no pureuser@"${cbs_array_aws.cbs_aws.management_endpoint}" purevol create epic-iscsi-vol --size 1TB
    ssh -i /home/ec2-user/.ssh/cbs-mgmt-key -oStrictHostKeyChecking=no pureuser@"${cbs_array_aws.cbs_aws.management_endpoint}" purevol connect epic-iscsi-vol --host linux-iscsi-host
    iscsiadm -m iface -I iscsi0 -o new
    iscsiadm -m iface -I iscsi1 -o new
    iscsiadm -m iface -I iscsi2 -o new
    iscsiadm -m iface -I iscsi3 -o new
    iscsiadm -m discovery -t st -p "${cbs_array_aws.cbs_aws.iscsi_endpoint_ct0}"
    iscsiadm -m node --login
    # iscsiadm -m node -p <ct0-iscsi-ip> --login
    # iscsiadm -m node -p <ct1-iscsi-ip> --login
    iscsiadm -m node -L automatic
    #service multipathd restart
    mkdir /mnt/epic-cbs-vol
    disk=`multipath -ll|awk '{print $1;exit}'`
    mkfs.ext4 /dev/mapper/$disk
    mount /dev/mapper/$disk /mnt/epic-cbs-vol
  EOF1
}
