#!/bin/bash

AWS_IAM_KEY_CSV_DATA=$AWS_IAM_KEY_CSV_DATA

AWS_USER_DIR="$HOME/.aws"
AWS_CONFIG_FILE="$AWS_USER_DIR/config"
AWS_CREDENTIALS_FILE="$AWS_USER_DIR/credentials"

if echo "$AWS_IAM_KEY_CSV_DATA" | grep -E '^([A-Za-z0-9+/=]|[\t\n\f\r ])*$' >/dev/null; then
    AWS_IAM_KEY_CSV_DATA=$(echo "$AWS_IAM_KEY_CSV_DATA" | base64 -d)
    echo "The data is decoded from base64 encoded data to plain data."
else
    echo "The data is plain (decoded) data."
fi

if  [ -d "$AWS_USER_DIR" ]; then
    echo ""$AWS_USER_DIR" directory is already exists"
else
    mkdir "$AWS_USER_DIR"
    echo ""$AWS_USER_DIR" directory is created"
fi

if  [ -f "$AWS_CONFIG_FILE" ]; then
    rm -rf "$AWS_CONFIG_FILE"
    touch "$AWS_CONFIG_FILE"
    echo ""$AWS_CONFIG_FILE" file is recreated"
else
    touch "$AWS_CONFIG_FILE"
    echo ""$AWS_CONFIG_FILE" file is created"
fi

if  [ -f "$AWS_CREDENTIALS_FILE" ]; then
    rm -rf "$AWS_CREDENTIALS_FILE"
    touch "$AWS_CREDENTIALS_FILE"
    echo ""$AWS_CREDENTIALS_FILE" file is recreated"
else
    touch "$AWS_CREDENTIALS_FILE"
    echo ""$AWS_CREDENTIALS_FILE" file is created"
fi

USER_COUNT=$(($(echo "$AWS_IAM_KEY_CSV_DATA" | tr -d '\r' | grep -v '^$' | wc -l) - 1))

declare -A AWS_REGION_CODES=(
    ["Tokyo"]="ap-northeast-1"
    ["Seoul"]="ap-northeast-2"
    ["Osaka"]="ap-northeast-3"
    ["Mumbai"]="ap-south-1"
    ["Singapore"]="ap-southeast-1"
    ["Sydney"]="ap-southeast-2"  
    ["Virginia"]="us-east-1"
    ["Ohio"]="us-east-2"
    ["California"]="us-west-1"
    ["Oregon"]="us-west-2"
    ["Central"]="ca-central-1"
    ["SaoPaulo"]="sa-east-1"
    ["Ireland"]="eu-west-1"
    ["London"]="eu-west-2"
    ["Frankfurt"]="eu-central-1"
    ["Paris"]="eu-west-3"
    ["Stockholm"]="eu-north-1"
)

for (( USER_NUMBER = 1; USER_NUMBER <= $USER_COUNT; USER_NUMBER++ ));
do
    USER=$(($USER_NUMBER + 1))
    AWS_USER=$(echo "$AWS_IAM_KEY_CSV_DATA" | awk -F',' -v user="$USER" 'NR==user {print $1}' | tr -d '\r')
    AWS_IAM_KEY_ID=$(echo "$AWS_IAM_KEY_CSV_DATA" | awk -F',' -v user="$USER" 'NR==user {print $2}' | tr -d '\r')
    AWS_IAM_KEY_SECRET=$(echo "$AWS_IAM_KEY_CSV_DATA" | awk -F',' -v user="$USER" 'NR==user {print $3}' | tr -d '\r')
    AWS_DEFAULT_REGION=$(echo "$AWS_IAM_KEY_CSV_DATA" | awk -F',' -v user="$USER" 'NR==user {print $4}' | tr -d '\r')

    {
        echo "[profile "$AWS_USER"]"
        echo "region = ${AWS_REGION_CODES[$AWS_DEFAULT_REGION]}"
    } | sed -e 's/^ *//' >> "$AWS_CONFIG_FILE"

    {
        echo "["$AWS_USER"]"
        echo "aws_access_key_id = $AWS_IAM_KEY_ID"
        echo "aws_secret_access_key = $AWS_IAM_KEY_SECRET"
    } | sed -e 's/^ *//' >> "$AWS_CREDENTIALS_FILE"

    for AWS_REGION_CODE in "${!AWS_REGION_CODES[@]}" 
    do
        {
            echo "[profile "$AWS_USER"-"$AWS_REGION_CODE"]"
            echo "region = ${AWS_REGION_CODES[$AWS_REGION_CODE]}"
        } | sed -e 's/^ *//' >> "$AWS_CONFIG_FILE"

        {
            echo "["$AWS_USER"-"$AWS_REGION_CODE"]"
            echo "aws_access_key_id = $AWS_IAM_KEY_ID"
            echo "aws_secret_access_key = $AWS_IAM_KEY_SECRET"
        } | sed -e 's/^ *//' >> "$AWS_CREDENTIALS_FILE"        
    done

    echo "$AWS_USER profile is set" 
    echo "$AWS_USER credentials is set"
    
done