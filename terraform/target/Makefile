all: nlb.tf.json terraform

terraform:
	terraform init

nlb.tf.json:
	aws ec2 describe-instances --filters 'Name=instance-state-name,Values=running' 'Name=tag:Vuls,Values=1' | jq '[.Reservations[].Instances[].SubnetId] | unique | . as $$subnets | first | {"locals": {"default_nlb_arn": "$${module.\(.).nlb.arn}"}, "module": $$subnets | [.[] as $$id | {"key": "\($$id)", "value": {"source": "./nlb","subnet_ids": ["\($$id)"]}}] | from_entries}' > $@

.PHONY: all terraform nlb.tf.json
