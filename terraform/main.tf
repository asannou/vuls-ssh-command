provider "aws" {
  region = "ap-northeast-1"
}

data "aws_caller_identity" "aws" {}

resource "aws_ssm_document" "vuls" {
  name = "CreateVulsUser"
  document_type = "Command"
  content = "${file("CreateVulsUser.json")}"
}

data "template_file" "vuls" {
  template = "${file("SSMVulsUser.json")}"
  vars {
    account_id = "${data.aws_caller_identity.aws.account_id}"
    document_name = "${aws_ssm_document.vuls.name}"
  }
}

resource "aws_iam_policy" "vuls" {
  name = "SSMVulsUser"
  path = "/"
  policy = "${data.template_file.vuls.rendered}"
}

variable "vuls_roles" {
  type = "list"
}

variable "vuls_users" {
  type = "list"
}

resource "aws_iam_policy_attachment" "vuls" {
  name = "vuls"
  roles = "${var.vuls_roles}"
  users = "${var.vuls_users}"
  policy_arn = "${aws_iam_policy.vuls.arn}"
}
