all: vpce_svc.tf.json terraform

terraform:
	terraform init

vpce_svc.tf.json:
	aws ec2 describe-instances --filters 'Name=tag:Vuls,Values=1' | jq -r '[.Reservations[].Instances[].SubnetId] | unique | .[]' | xargs aws ec2 describe-subnets --subnet-ids | jq -f vpce_svc.jq > $@

.PHONY: all terraform vpce_svc.tf.json
