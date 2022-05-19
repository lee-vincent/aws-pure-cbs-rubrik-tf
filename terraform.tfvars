# See blog at https://davidstamen.com/2021/07/26/pure-cloud-block-store-on-aws-jump-start/ for more information on AWS Jump Start


#AWS Variables
aws_prefix = "tf-cbs-"
aws_region = "us-east-1"
# If multiple private subnets are used for Cloud Block Store, they must be all in the same Availability zone.
aws_zone          = "a"
aws_instance_type = "t2.micro"
aws_key_name      = "pure-cbs-key-pair"
# use this to connect the linux iscsi client to pure cbs instance
aws_user_data = <<EOF
        #!/bin/bash
        echo "hi" > /tmp/user_data.txt
        EOF
profile       = "bilh"
#CBS Variables
template_url         = "https://s3.amazonaws.com/awsmp-fulfillment-cf-templates-prod/4ea2905b-7939-4ee0-a521-d5c2fcb41214/e0c722f95e6644c6aa323ef49749deb1.template"
log_sender_domain    = "ahead.com"
alert_recipients     = ["vinnie.lee@ahead.com"]
purity_instance_type = "V10AR1"
license_key          = "CBS-TRIAL-LICENSE"
# aws_public_key   set witht the value of TF_VAR_aws_public_key
# aws_ami_architecture = "x86_64"