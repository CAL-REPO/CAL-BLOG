#!/bin/bash

S3_BUCKET_NAME=$S3_BUCKET_NAME
S3_BUCKET_PROFILE=$S3_BUCKET_PROFILE

if [ -z "$S3_BUCKET_PROFILE" ]; then
    AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
    AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
else
    AWS_PROFILE="--profile $S3_BUCKET_PROFILE"
fi

EXISTING_S3_BUCKET=$(aws s3 ls "s3://$S3_BUCKET_NAME" $AWS_PROFILE 2>&1)

if [[ $EXISTING_S3_BUCKET == *"AccessDenied"* ]]; then
    echo ""$S3_BUCKET_NAME" can not be used for s3 bucket name."
    echo "Check AWS configure profile first"
    echo "S3 bucket name should be only one globally"
elif [[ $EXISTING_S3_BUCKET == *"NoSuchBucket"* ]]; then
    aws s3 mb "s3://$S3_BUCKET_NAME" $AWS_PROFILE
    echo ""$S3_BUCKET_NAME" is created."    
else
    echo ""$S3_BUCKET_NAME" is already exists."
fi