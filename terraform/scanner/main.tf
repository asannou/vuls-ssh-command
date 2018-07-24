provider "aws" {
  region = "ap-northeast-1"
}

data "aws_caller_identity" "aws" {}

variable "target_account_ids" {
  type = "list"
}

variable "vuls_role" {
  type = "string"
}

resource "aws_iam_policy" "vuls" {
  count = "${length(var.target_account_ids)}"
  name = "STSAssumeRoleVuls-${var.target_account_ids[count.index]}"
  policy = "${data.template_file.vuls.*.rendered[count.index]}"
}

data "template_file" "vuls" {
  count = "${length(var.target_account_ids)}"
  template = "${file("STSAssumeRoleVuls.json")}"
  vars {
    account_id = "${data.aws_caller_identity.aws.account_id}"
    target_account_id = "${var.target_account_ids[count.index]}"
  }
}

resource "aws_iam_role_policy_attachment" "vuls" {
  count = "${length(var.target_account_ids)}"
  role = "${var.vuls_role}"
  policy_arn = "${aws_iam_policy.vuls.*.arn[count.index]}"
}
