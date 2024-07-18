#!/bin/bash

# BACKEND_DYNAMODB_TABLE=

# aws dynamodb create-table \
#     --table-name cal-terraform-lock \
#     --attribute-definitions \
#     AttributeName=ID,AttributeType=N \
#     AttributeName=Name,AttributeType=S \
#     --key-schema \
#     AttributeName=ID,KeyType=HASH \
#     --provisioned-throughput \
#     ReadCapacityUnits=5,WriteCapacityUnits=5 \
#     --tags \
#     Key=Environment,Value=Production \
#     Key=Project,Value=YourProjectName \
#     --profile="$AWS_PROFILE"
