[Setup Amazon EC2 Systems Manager](http://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-setting-up.html).

```
$ aws sts get-caller-identity --output text --query Arn
arn:aws:iam::123456789012:root
$ terraform apply
var.vuls_roles
  Enter a value: []

var.vuls_users
  Enter a value: ["Bob"]

...
```

```
$ export AWS_PROFILE=bob
$ aws sts get-caller-identity --output text --query Arn
arn:aws:iam::123456789012:user/Bob
$ aws ssm send-command --document-name CreateVulsUser --instance-ids i-0cb2b964d3e14fd9f --parameters authorizedkeys="$(cat $HOME/.ssh/id_rsa.pub)"
```
