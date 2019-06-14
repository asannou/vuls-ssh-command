locals {
  vuls_principal_arn = "arn:aws:iam::${var.vuls_account_id}:root"
}

resource "aws_vpc_endpoint_service" "vpce-service" {
  acceptance_required = true
  network_load_balancer_arns = ["${local.default_nlb_arn}"]
  lifecycle {
    ignore_changes = ["network_load_balancer_arns"]
  }
}

resource "aws_vpc_endpoint_service_allowed_principal" "principal" {
  vpc_endpoint_service_id = "${aws_vpc_endpoint_service.vpce-service.id}"
  principal_arn = "${local.vuls_principal_arn}"
}

output "vpce-service.id" {
  value = "${aws_vpc_endpoint_service.vpce-service.id}"
}

output "vpce-service.service_name" {
  value = "${aws_vpc_endpoint_service.vpce-service.service_name}"
}

