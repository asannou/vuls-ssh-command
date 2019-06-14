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

resource "aws_iam_policy" "ssm-vuls" {
  name = "SSMVulsUser"
  path = "/"
  policy = "${data.aws_iam_policy_document.ssm-vuls.json}"
}

data "aws_iam_policy_document" "ssm-vuls" {
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

resource "aws_iam_role_policy_attachment" "ssm-vuls" {
  role = "${aws_iam_role.vuls.name}"
  policy_arn = "${aws_iam_policy.ssm-vuls.arn}"
}

resource "aws_ssm_document" "vuls" {
  name = "CreateVulsUser"
  document_type = "Command"
  content = "${file("CreateVulsUser.json")}"
}

resource "aws_s3_bucket" "vuls" {
  bucket = "vuls-ssm-output-${var.vuls_account_id}-${data.aws_caller_identity.aws.account_id}"
  acl = "private"
  force_destroy = true
}

