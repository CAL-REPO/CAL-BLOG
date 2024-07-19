#!/bin/bash

AWS_PROFILE=$AWS_PROFILE
S3_BUCKET_NAME=$S3_BUCKET_NAME
S3_BUCKET_OBJ_KEY=$S3_BUCKET_OBJ_KEY
LOCAL_FILE_PATH=$LOCAL_FILE_PATH
FILE_PERSMISSION=$FILE_PERSMISSION
FILE_OWNER=$FILE_OWNER
FILE_GROUP=$FILE_GROUP

AWS_CONF="$HOME/.aws/config"
AWS_CRED="$HOME/.aws/credentials"

if [ ! -f $AWS_CONF ]; then
    echo "\"$AWS_CONF\" is not exists."
    exit 1 
fi

if [ ! -f $AWS_CRED ]; then
    echo "\"$AWS_CRED\" is not exists."
    exit 1 
fi

if [ ! -z $AWS_PROFILE ]; then
    if ! grep -q "$AWS_PROFILE" "$AWS_CONF"; then
        echo "\"$AWS_PROFILE\" aws configuration is not set in \"$AWS_CONF\""
        exit 1
    fi
    if ! grep -q "$AWS_PROFILE" "$AWS_CRED"; then
        echo "\"$AWS_PROFILE\" aws credential is not set in \"$AWS_CRED\""        
        exit 1
    fi
else
    echo "Variable \"AWS_PROFILE\" is not set."
    exit 1
fi

if [ ! -z $LOCAL_FILE_PATH ]; then
    LOCAL_DIR_PATH=$(dirname $LOCAL_FILE_PATH)
    if [ ! -d $LOCAL_DIR_PATH ]; then
        echo "\"$LOCAL_DIR_PATH\" directory is not exists."
        exit 1
    fi
else
    echo "Variable \"LOCAL_FILE_PATH\" is not set."
    exit 1
fi

if [ ! -z $S3_BUCKET_NAME ]; then
    if ! aws s3api head-bucket --bucket $S3_BUCKET_NAME --profile $AWS_PROFILE >/dev/null 2>&1; then
        echo "\"$S3_BUCKET_NAME\" s3 bucket is not exists."
        exit 1
    fi
else
    echo "Variable \"S3_BUCKET_NAME\" is not set."
    exit 1
fi

if [ ! -z $S3_BUCKET_OBJ_KEY ]; then
    if aws s3api head-object --bucket $S3_BUCKET_NAME --key $S3_BUCKET_OBJ_KEY --profile $AWS_PROFILE >/dev/null 2>&1; then
        echo "downloading \"s3://$S3_BUCKET_NAME/$S3_BUCKET_OBJ_KEY\"..."
        aws s3 cp "s3://$S3_BUCKET_NAME/$S3_BUCKET_OBJ_KEY" "$LOCAL_FILE_PATH" --profile $AWS_PROFILE
        while [ ! -f "$LOCAL_FILE_PATH" ]; do
            echo "searching for \"$LOCAL_FILE_PATH\"..."
            sleep 3
        done
        echo "\"$LOCAL_FILE_PATH\" is downloaded."
        if [ ! -z $FILE_PERSMISSION ]; then
            sudo chmod $FILE_PERSMISSION "$LOCAL_FILE_PATH"
            echo "\"$LOCAL_FILE_PATH\" file permission is set as $FILE_PERSMISSION"
        else
            DEFAULT_FILE_PERMISSION=$(stat -c "%a" "$LOCAL_FILE_PATH")
            echo "\"$LOCAL_FILE_PATH\" file permission is $DEFAULT_FILE_PERMISSION by default file permission"
        fi

        if [[ ! -z $FILE_OWNER && ! -z $FILE_GROUP ]]; then
            sudo chown $FILE_OWNER:$FILE_GROUP "$LOCAL_FILE_PATH"
            echo "\"$LOCAL_FILE_PATH\" owner and group is set as $FILE_OWNER:$FILE_GROUP"

        elif [[ -z $FILE_OWNER && ! -z $FILE_GROUP ]]; then
            DEFAULT_OWNER=$(stat -c "%U" "$LOCAL_FILE_PATH")
            sudo chown $DEFAULT_OWNER:$FILE_GROUP "$LOCAL_FILE_PATH"
            echo "\"$LOCAL_FILE_PATH\" owner is $FILE_OWNER by default file owner"
            echo "\"$LOCAL_FILE_PATH\" group is set as $FILE_GROUP"

        elif [[ ! -z $FILE_OWNER && -z $FILE_GROUP ]]; then
            DEFAULT_GROUP=$(stat -c "%G" "$LOCAL_FILE_PATH")
            sudo chown $FILE_OWNER:$DEFAULT_GROUP "$LOCAL_FILE_PATH"
            echo "\"$LOCAL_FILE_PATH\" owner is set as $FILE_OWNER"
            echo "\"$LOCAL_FILE_PATH\" group is $DEFAULT_GROUP by default file group"

        elif [[ -z $FILE_OWNER && -z $FILE_GROUP ]]; then
            DEFAULT_OWNER=$(stat -c "%U" "$LOCAL_FILE_PATH")
            DEFAULT_GROUP=$(stat -c "%G" "$LOCAL_FILE_PATH")
            sudo chown $DEFAULT_OWNER:$DEFAULT_GROUP "$LOCAL_FILE_PATH"
            echo "\"$LOCAL_FILE_PATH\" owner and group is $DEFAULT_OWNER:$DEFAULT_GROUP by default file owner and group"
        fi
        echo "setting \"$LOCAL_FILE_PATH\" file permission, owner, group is done."
        exit 0
    else
        echo "\"s3://$S3_BUCKET_NAME/$S3_BUCKET_OBJ_KEY\" s3 bucket object is not exists."
        exit 1
    fi
else
    echo "Variable \"S3_BUCKET_OBJ_KEY\" is not set."
    exit 1
fi