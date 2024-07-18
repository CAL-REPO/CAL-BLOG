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
    echo ""$S3_BUCKET_NAME" s3 bucket access is denied."
    echo "Check s3 bucket name "$S3_BUCKET_NAME" is right."
    echo "Check AWS configure profile."
elif [[ $EXISTING_S3_BUCKET == *"NoSuchS3_Bucket"* ]]; then
    echo ""$S3_BUCKET_NAME" s3 bucket is not exists."
    echo "Check s3 bucket name "$S3_BUCKET_NAME" is right."
    echo "Check AWS configure profile."
else
    aws s3 rb "s3://$S3_BUCKET_NAME" $AWS_PROFILE --force
    echo "$S3_BUCKET_NAME is deleted"
fi