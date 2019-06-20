variable "aws_region" {
  type = "string"
}

provider "aws" {
  region = "${var.aws_region}"
}

data "aws_caller_identity" "aws" {}

variable "vuls_account_id" {
  type = "string"
}

variable "vuls_role" {
  type = "string"
}

resource "aws_iam_role" "vuls" {
  name = "VulsRole-${var.vuls_account_id}"
  path = "/"
  assume_role_policy = "${data.aws_iam_policy_document.vuls.json}"
}

data "aws_iam_policy_document" "vuls" {
  statement {
    principals {
      type = "AWS"
      identifiers = ["arn:aws:iam::${var.vuls_account_id}:role/${var.vuls_role}"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_policy" "vuls-ssm" {
  name = "VulsSSMAccess"
  path = "/"
  policy = "${data.aws_iam_policy_document.vuls-ssm.json}"
}

data "aws_iam_policy_document" "vuls-ssm" {
  statement {
    actions = ["ec2:DescribeInstances"]
    resources = ["*"]
  }
  statement {
    actions = ["ssm:SendCommand"]
    resources = [
      "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.aws.account_id}:document/${aws_ssm_document.vuls.name}",
      "arn:aws:s3:::${aws_s3_bucket.vuls.bucket}"
    ]
  }
  statement {
    actions = ["ssm:SendCommand"]
    resources = ["arn:aws:ec2:${var.aws_region}:${data.aws_caller_identity.aws.account_id}:instance/*"]
    condition {
      test = "StringEquals"
      variable = "ssm:resourceTag/Vuls"
      values = ["1"]
    }
  }
  statement {
    actions = ["ssm:ListCommands"]
    resources = ["*"]
  }
  statement {
    actions = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.vuls.bucket}/*"]
  }
}

resource "aws_iam_role_policy_attachment" "vuls-ssm" {
  role = "${aws_iam_role.vuls.name}"
  policy_arn = "${aws_iam_policy.vuls-ssm.arn}"
}

resource "aws_iam_policy" "vuls-privatelink" {
  name = "VulsPrivateLink"
  path = "/"
  policy = "${data.aws_iam_policy_document.vuls-privatelink.json}"
}

data "aws_iam_policy_document" "vuls-privatelink" {
  statement {
    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeVpcEndpointServiceConfigurations"
    ]
    resources = ["*"]
  }
  statement {
    actions = ["ec2:AcceptVpcEndpointConnections"]
    resources = ["*"]
    condition {
      test = "StringEquals"
      variable = "ec2:ResourceTag/Name"
      values = ["vuls"]
    }
  }
  statement {
    actions = [
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:DescribeTargetHealth"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy_attachment" "vuls-privatelink" {
  role = "${aws_iam_role.vuls.name}"
  policy_arn = "${aws_iam_policy.vuls-privatelink.arn}"
}

locals {
  create_vuls_user = {
    schemaVersion = "2.0"
    description = "Create a new user for Vuls."
    parameters = {
      publickey = {
        type = "String"
        description = "(Required) SSH public key"
        default = ""
        displayType = "textarea"
        allowedPattern = "^[ +\\-./=@0-9A-Za-z]+$"
      }
    }
    mainSteps = [
      {
        action = "aws:runShellScript",
        name = "runShellScript",
        inputs = {
          runCommand = "${split("\n", file("create_vuls_user.sh"))}"
        }
      }
    ]
  }
}

resource "aws_ssm_document" "vuls" {
  name = "CreateVulsUser"
  document_type = "Command"
  content = "${jsonencode(local.create_vuls_user)}"
}

resource "aws_s3_bucket" "vuls" {
  bucket = "vuls-ssm-output-${var.vuls_account_id}-${data.aws_caller_identity.aws.account_id}"
  acl = "private"
  force_destroy = true
}

