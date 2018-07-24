provider "aws" {
  region = "ap-northeast-1"
}

data "aws_caller_identity" "aws" {}

variable "vuls_account_id" {
  type = "string"
}

variable "vuls_role_name" {
  type = "string"
}

resource "aws_iam_role" "vuls" {
  name = "VulsRole-${var.vuls_account_id}"
  path = "/"
  assume_role_policy = <<EOD
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.vuls_account_id}:role/${var.vuls_role_name}"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOD
}

resource "aws_iam_policy" "ssm-vuls" {
  name = "SSMVulsUser"
  path = "/"
  policy = "${data.template_file.ssm-vuls.rendered}"
}

resource "aws_iam_role_policy_attachment" "ssm-vuls" {
  role = "${aws_iam_role.vuls.name}"
  policy_arn = "${aws_iam_policy.ssm-vuls.arn}"
}

data "template_file" "ssm-vuls" {
  template = "${file("SSMVulsUser.json")}"
  vars {
    account_id = "${data.aws_caller_identity.aws.account_id}"
    document_name = "${aws_ssm_document.vuls.name}"
  }
}

resource "aws_ssm_document" "vuls" {
  name = "CreateVulsUser"
  document_type = "Command"
  content = "${file("CreateVulsUser.json")}"
}

