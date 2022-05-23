# See blog at https://davidstamen.com/2021/07/26/pure-cloud-block-store-on-aws-jump-start/ for more information on AWS Jump Start

# AWS Variables
aws_prefix  = "tf-cbs-"
aws_region  = "us-east-1"
aws_profile = "bilh"
# If multiple private subnets are used for Cloud Block Store, they must be all in the same Availability zone.
aws_zone                      = "a"
aws_bastion_instance_type     = "t3.large"
bilh_aws_demo_master_key_name = "bilh-aws-demo-master-key"

# CBS Variables
# Purity version 6.25
template_url         = "https://s3.amazonaws.com/awsmp-fulfillment-cf-templates-prod/4ea2905b-7939-4ee0-a521-d5c2fcb41214/e0c722f95e6644c6aa323ef49749deb1.template"
log_sender_domain    = "ahead.com"
alert_recipients     = ["vinnie.lee@ahead.com"]
purity_instance_type = "V10AR1"
license_key          = "CBS-TRIAL-LICENSE"
# bilh_aws_demo_master_key_pub = set in local environment by TF_VAR_bilh_aws_demo_master_key_pub
