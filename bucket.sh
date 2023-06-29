#!/bin/bash
set -e
export AWS_DEFAULT_REGION=us-east-1
aws s3api create-bucket --bucket abdnikamn
aws s3api put-object --bucket abdnikamn --key dev/eks-cluster/
aws s3api put-object --bucket abdnikamn --key dev/aws-lbc/
aws s3api put-object --bucket abdnikamn --key dev/aws-lbc-ingress/

aws dynamodb create-table \
    --table-name abdnikam-lbc \
    --attribute-definitions \
        AttributeName=LockID,AttributeType=S \
    --key-schema \
        AttributeName=LockID,KeyType=HASH \
    --provisioned-throughput \
        ReadCapacityUnits=10,WriteCapacityUnits=5
        
aws dynamodb create-table \
    --table-name abdnikam \
    --attribute-definitions \
        AttributeName=LockID,AttributeType=S \
    --key-schema \
        AttributeName=LockID,KeyType=HASH \
    --provisioned-throughput \
        ReadCapacityUnits=10,WriteCapacityUnits=5
terraform -chdir=01-ekscluster-terraform-manifests/ init -reconfigure
terraform -chdir=01-ekscluster-terraform-manifests/ apply --auto-approve
terraform -chdir=02-lbc-install-terraform-manifests/ init -reconfigure
terraform -chdir=02-lbc-install-terraform-manifests/ apply --auto-approve
aws eks --region us-east-1 update-kubeconfig --name hr-dev-eksdemo1
