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
  ami                    = data.aws_ami.amazon_linux2.image_id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.cbs_iscsi.id, aws_security_group.bastion.id]
  get_password_data      = false
  subnet_id              = aws_subnet.workload.id
  key_name               = var.aws_key_name
  tags = {
    Name = "iscsi_workload"
  }
  # user_data = <<EOF
  #       #!/bin/bash
  #       yum update -y
  #       yum -y install iscsi-initiator-utils
  #       yum -y install lsscsi
  #       yum -y install device-mapper-multipath
  #       service iscsid start
  #       amazon-linux-extras install epel -y
  #       yum install sshpass -y
  #       iqn=`awk -F= '{ print $2 }' /etc/iscsi/initiatorname.iscsi`
  #       sshpass -p pureuser ssh  -oStrictHostKeyChecking=no pureuser@<ctmgmt-vip>> purehost create <hostnameforpure> --iqnlist $iqn
  #       sshpass -p pureuser ssh  -oStrictHostKeyChecking=no pureuser@<ctmgmt-vip> purehost connect --vol <purevolname> <hostnameforpure>
  #       iscsiadm -m iface -I iscsi0 -o new
  #       iscsiadm -m iface -I iscsi1 -o new
  #       iscsiadm -m iface -I iscsi2 -o new
  #       iscsiadm -m iface -I iscsi3 -o new
  #       iscsiadm -m discovery -t st -p <ct0-iscsi-ip>:3260
  #       iscsiadm -m node -p <ct0-iscsi-ip> --login
  #       iscsiadm -m node -p <ct1-iscsi-ip> --login
  #       iscsiadm -m node -L automatic
  #       mpathconf --enable --with_multipathd y
  #       service multipathd restart
  #       mkdir /mnt/cbsvol
  #       disk=`multipath -ll|awk '{print $1;exit}'`
  #       mount /dev/mapper/$disk /mnt/cbsvol
  #       EOF
}
