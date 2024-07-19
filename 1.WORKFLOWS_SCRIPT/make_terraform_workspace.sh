#!/bin/bash

TERRAFORM_WORKSPACE_NAME=$TERRAFORM_WORKSPACE_NAME

if terraform workspace list | grep -q "$TERRAFORM_WORKSPACE_NAME"; then
    echo "The \"$TERRAFORM_WORKSPACE_NAME\" workspace already exists."
else
    terraform workspace new "$TERRAFORM_WORKSPACE_NAME"
    echo "The \"$TERRAFORM_WORKSPACE_NAME\" workspace is created."
fi