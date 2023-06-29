#!/bin/bash
#set -e
terraform -chdir=02-lbc-install-terraform-manifests/ destroy --auto-approve -lock=false
terraform -chdir=01-ekscluster-terraform-manifests/ destroy --auto-approve  -lock=false

aws dynamodb delete-table --table-name abdnikam
aws dynamodb delete-table --table-name abdnikam-lbc
aws s3 rb s3://abdnikamn --force
