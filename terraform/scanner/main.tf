variable "aws_region" {
  type = "string"
}

provider "aws" {
  region = "${var.aws_region}"
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
  policy = "${data.aws_iam_policy_document.vuls.*.json[count.index]}"
}

data "aws_iam_policy_document" "vuls" {
  count = "${length(var.target_account_ids)}"
  statement {
    actions = ["sts:AssumeRole"]
    resources = ["arn:aws:iam::${var.target_account_ids[count.index]}:role/VulsRole-${data.aws_caller_identity.aws.account_id}"]
  }
}

resource "aws_iam_role_policy_attachment" "vuls" {
  count = "${length(var.target_account_ids)}"
  role = "${var.vuls_role}"
  policy_arn = "${aws_iam_policy.vuls.*.arn[count.index]}"
}
