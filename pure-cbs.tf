provider "cbs" {
  aws {
    region = var.aws_region
  }
}
#in aws terraform provider 4.16.0 this idempotence issue is fixed 
# resource "aws_iam_service_linked_role" "autoscaling_dynamodb_role" {
#   aws_service_name = "dynamodb.application-autoscaling.amazonaws.com"
# }
# resource "aws_iam_role_policy_attachment" "autoscaling_dynamodb_role_policy_attachment" {
#   role       = aws_iam_service_linked_role.autoscaling_dynamodb_role.name
#   policy_arn = "arn:aws:iam::aws:policy/aws-service-role/AWSApplicationAutoscalingDynamoDBTablePolicy"
# }
resource "aws_iam_role" "cbs_role" {
  name = format("%s%s%s", var.aws_prefix, var.aws_region, "-cbs-iamrole")
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "cloudformation.amazonaws.com"
        }
      },
    ]
  })
}
resource "aws_iam_role_policy" "cbs_role_policy" {
  name = format("%s%s%s", var.aws_prefix, var.aws_region, "-cbs-iamrolepolicy")
  role = aws_iam_role.cbs_role.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "application-autoscaling:DeleteScalingPolicy",
          "application-autoscaling:DeregisterScalableTarget",
          "application-autoscaling:DescribeScalableTargets",
          "application-autoscaling:DescribeScalingPolicies",
          "application-autoscaling:DescribeScheduledActions",
          "application-autoscaling:PutScalingPolicy",
          "application-autoscaling:RegisterScalableTarget",
          "autoscaling:CreateAutoScalingGroup",
          "autoscaling:CreateLaunchConfiguration",
          "autoscaling:CreateOrUpdateTags",
          "autoscaling:DeleteAutoScalingGroup",
          "autoscaling:DeleteLaunchConfiguration",
          "autoscaling:DeleteTags",
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeScalingActivities",
          "autoscaling:DescribeTags",
          "autoscaling:PutLifecycleHook",
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup",
          "autoscaling:UpdateAutoScalingGroup",
          "dynamodb:CreateTable",
          "dynamodb:DeleteTable",
          "dynamodb:DescribeTable",
          "dynamodb:ListTables",
          "dynamodb:ListTagsOfResource",
          "dynamodb:TagResource",
          "dynamodb:UntagResource",
          "dynamodb:UpdateTable",
          "ec2:AttachNetworkInterface",
          "ec2:AttachVolume",
          "ec2:AuthorizeSecurityGroupEgress",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:CreateNetworkInterface",
          "ec2:CreatePlacementGroup",
          "ec2:CreateSecurityGroup",
          "ec2:CreateTags",
          "ec2:CreateVolume",
          "ec2:CreateLaunchTemplate",
          "ec2:CreateLaunchTemplateVersion",
          "ec2:DeleteLaunchTemplate",
          "ec2:DeleteNetworkInterface",
          "ec2:DeletePlacementGroup",
          "ec2:DeleteSecurityGroup",
          "ec2:DeleteTags",
          "ec2:DeleteVolume",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeImages",
          "ec2:DescribeInstances",
          "ec2:DescribeKeyPairs",
          "ec2:DescribeLaunchTemplates",
          "ec2:DescribeLaunchTemplateVersions",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribePlacementGroups",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeTags",
          "ec2:DescribeVolumes",
          "ec2:DescribeVolumesModifications",
          "ec2:DescribeVpcs",
          "ec2:DetachNetworkInterface",
          "ec2:ModifyNetworkInterfaceAttribute",
          "ec2:ModifyVolumeAttribute",
          "ec2:ModifyInstanceAttribute",
          "ec2:RevokeSecurityGroupEgress",
          "ec2:RevokeSecurityGroupIngress",
          "ec2:RunInstances",
          "ec2:StartInstances",
          "ec2:StopInstances",
          "ec2:TerminateInstances",
          "iam:AddRoleToInstanceProfile",
          "iam:AttachRolePolicy",
          "iam:CreateInstanceProfile",
          "iam:CreatePolicy",
          "iam:CreateRole",
          "iam:CreateServiceLinkedRole",
          "iam:DeleteInstanceProfile",
          "iam:DeletePolicy",
          "iam:DeleteRole",
          "iam:DeleteRolePolicy",
          "iam:DetachRolePolicy",
          "iam:GetInstanceProfile",
          "iam:GetPolicy",
          "iam:GetRole",
          "iam:GetRolePolicy",
          "iam:ListRoleTags",
          "iam:PassRole",
          "iam:PutRolePolicy",
          "iam:RemoveRoleFromInstanceProfile",
          "iam:SimulatePrincipalPolicy",
          "iam:TagRole",
          "iam:UntagRole",
          "kms:CreateAlias",
          "kms:CreateKey",
          "kms:DeleteAlias",
          "kms:DescribeKey",
          "kms:DisableKey",
          "kms:EnableKey",
          "kms:ListAliases",
          "kms:ListKeyPolicies",
          "kms:ListKeys",
          "kms:ListResourceTags",
          "kms:PutKeyPolicy",
          "kms:ScheduleKeyDeletion",
          "kms:TagResource",
          "kms:UntagResource",
          "kms:UpdateAlias",
          "lambda:CreateFunction",
          "lambda:DeleteFunction",
          "lambda:GetFunction",
          "lambda:GetFunctionConfiguration",
          "lambda:InvokeFunction",
          "lambda:ListTags",
          "lambda:TagResource",
          "lambda:UntagResource",
          "lambda:UpdateFunctionCode",
          "lambda:UpdateFunctionConfiguration",
          "s3:CreateBucket",
          "s3:DeleteBucket",
          "s3:DeleteBucketPolicy",
          "s3:GetBucketPolicy",
          "s3:GetBucketTagging",
          "s3:ListBucket",
          "s3:PutBucketPolicy",
          "s3:PutBucketTagging",
          "s3:PutBucketVersioning",
        "sts:assumerole"],
        "Resource" : "*"
      }
    ]
  })
}
resource "cbs_array_aws" "cbs_aws" {
  # make a script for removing cbs instance:
      # PURE_IP=10.0.2.222
      # ssh -i /home/ec2-user/.ssh/bilh_aws_demo_master_key -oStrictHostKeyChecking=no pureuser@$PURE_IP purehost disconnect linux-iscsi-host --vol epic-iscsi-vol
      # ssh -i /home/ec2-user/.ssh/bilh_aws_demo_master_key -oStrictHostKeyChecking=no pureuser@$PURE_IP purehost disconnect backup-proxy --vol backup-proxy-iscsi-vol
      # ssh -i /home/ec2-user/.ssh/bilh_aws_demo_master_key -oStrictHostKeyChecking=no pureuser@$PURE_IP purehost delete linux-iscsi-host
      # ssh -i /home/ec2-user/.ssh/bilh_aws_demo_master_key -oStrictHostKeyChecking=no pureuser@$PURE_IP purehost delete backup-proxy
      # ssh -i /home/ec2-user/.ssh/bilh_aws_demo_master_key -oStrictHostKeyChecking=no pureuser@$PURE_IP purevol destroy epic-iscsi-vol
      # ssh -i /home/ec2-user/.ssh/bilh_aws_demo_master_key -oStrictHostKeyChecking=no pureuser@$PURE_IP purevol destroy backup-proxy-iscsi-vol
      # ssh -i /home/ec2-user/.ssh/bilh_aws_demo_master_key -oStrictHostKeyChecking=no pureuser@$PURE_IP purevol eradicate epic-iscsi-vol
      # ssh -i /home/ec2-user/.ssh/bilh_aws_demo_master_key -oStrictHostKeyChecking=no pureuser@$PURE_IP purevol eradicate backup-proxy-iscsi-vol
      # TOKEN=$(ssh -i /home/ec2-user/.ssh/bilh_aws_demo_master_key -oStrictHostKeyChecking=no pureuser@$PURE_IP purearray factory-reset-token create | cut -d " " -f 3 | tr -d "[:space:]")
      # ssh -i /home/ec2-user/.ssh/bilh_aws_demo_master_key -oStrictHostKeyChecking=no pureuser@$PURE_IP purearray erase --factory-reset-token $TOKEN --eradicate-all-data

  # Prevents a successful 'terraform destroy' on Pure Cloud Block Store instances
  # To deprovisoin Pure CBS: 
  #   1. remove deletion protection from cloudformation
  #   2. pure cli: purearray factory-reset-token create
  #   3. pure cli: purearray erase --factory-reset-token <token> --eradicate-all-data
  #      wait about 20 minutes for the cloudformation template to delete all resources
  #   4. set prevent_destroy = false
  #   5. run 'terraform destroy'
  lifecycle {
    prevent_destroy = false
  }
  array_name                 = format("%s%s%s", var.aws_prefix, var.aws_region, "-cbs")
  deployment_template_url    = var.template_url
  deployment_role_arn        = aws_iam_role.cbs_role.arn
  log_sender_domain          = var.log_sender_domain
  alert_recipients           = var.alert_recipients
  array_model                = var.purity_instance_type
  license_key                = var.license_key
  pureuser_key_pair_name     = var.bilh_aws_demo_master_key_name
  system_subnet              = aws_subnet.sys.id
  replication_subnet         = aws_subnet.repl.id
  iscsi_subnet               = aws_subnet.iscsi.id
  management_subnet          = aws_subnet.mgmt.id
  replication_security_group = aws_security_group.cbs_repl.id
  iscsi_security_group       = aws_security_group.cbs_iscsi.id
  management_security_group  = aws_security_group.cbs_mgmt.id
  depends_on = [
    aws_internet_gateway.cbs_internet_gateway,
    aws_nat_gateway.cbs_nat_gateway,
    aws_iam_role.cbs_role,
    aws_iam_role_policy.cbs_role_policy,
    aws_security_group.cbs_iscsi,
    aws_security_group.cbs_mgmt,
    aws_security_group.cbs_repl,
    aws_subnet.iscsi,
    aws_subnet.mgmt,
    aws_subnet.repl,
    aws_subnet.sys,
    aws_vpc.cbs_vpc,
    aws_route_table_association.public,
    aws_route_table_association.sys,
    aws_route_table_association.mgmt,
    aws_vpc_endpoint.s3,
    aws_vpc_endpoint.dynamodb,
    aws_route_table.cbs_routetable,
    aws_eip.cbs_nat_gateway_eip
  ]
}