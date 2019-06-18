all: vpce_svc.tf.json terraform

terraform:
	terraform init

vpce_svc.tf.json:
	aws ec2 describe-instances --filters 'Name=instance-state-name,Values=running' 'Name=tag:Vuls,Values=1' | jq '[.Reservations[].Instances[].SubnetId] | unique | {"module": [.[] as $$id | {"key": "\($$id)", "value": {"source": "./vpce_svc", "vuls_account_id": "$${var.vuls_account_id}", "subnet_ids": ["\($$id)"]}}] | from_entries}' > $@

.PHONY: all terraform vpce_svc.tf.json
