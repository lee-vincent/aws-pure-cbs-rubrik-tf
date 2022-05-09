# See blog at https://davidstamen.com/2021/07/26/pure-cloud-block-store-on-aws-jump-start/ for more information on AWS Jump Start


#AWS Variables
aws_prefix = "tf-cbs-"
# aws_access_key = "000-000-000"
# aws_secret_key = "000-000-000"
aws_region = "us-east-1"
# If multiple private subnets are used for Cloud Block Store, they must be all in the same Availability zone.
aws_zone          = "a"
aws_instance_type = "t2.micro"
# aws_key_name      = "aws_keypair"
# user this user data for linux iscsi client?
aws_user_data = <<EOF
        #!/bin/bash
        echo "hi" > /tmp/user_data.txt
        EOF

#CBS Variables
template_url = "https://s3.amazonaws.com/awsmp-fulfillment-cf-templates-prod/4ea2905b-7939-4ee0-a521-d5c2fcb41214.18cd55bc-47be-45e3-8eaa-2b00c594fa57.template" //6.2.1
# template_url         = "https://s3.amazonaws.com/awsmp-fulfillment-cf-templates-prod/4ea2905b-7939-4ee0-a521-d5c2fcb41214/e0c722f95e6644c6aa323ef49749deb1.template"
# template_url           = "https://s3.amazonaws.com/awsmp-fulfillment-cf-templates-prod/4ea2905b-7939-4ee0-a521-d5c2fcb41214.6b728728-d8fa-4eb7-b92d-22d9aee3684c.template"
log_sender_domain    = "ahead.com"
alert_recipients     = ["vinnie.lee@ahead.com"]
purity_instance_type = "V10AR1"
license_key          = "CBS-TRIAL-LICENSE"
# aws_ami_architecture = "x86_64"