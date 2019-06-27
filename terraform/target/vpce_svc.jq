[
  .Subnets[] | {
    "name": .Tags[] | select(.Key == "Name") | .Value,
    "id": .SubnetId
  }
] | {
  "module": [
    .[] | .id as $id | {
      "key": "\(.name)_\(.id)",
      "value": {
        "source": "./vpce_svc",
        "vuls_account_id": "${var.vuls_account_id}",
        "subnet_ids": ["\($id)"]
      }
    }
  ] | from_entries,
  "locals": {
    "vpce_svc_ids": map("${module.\(.name)_\(.id).vpce-service.id}")
  }
}
