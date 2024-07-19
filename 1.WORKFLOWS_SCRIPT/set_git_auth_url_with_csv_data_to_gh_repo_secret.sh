#!/bin/bash

GIT_PROFILE_CSV_DATA=$GIT_PROFILE_CSV_DATA
GIT_USER_NAME=$GIT_USER_NAME
GIT_REPO=$GIT_REPO

if echo "$GIT_PROFILE_CSV_DATA" | grep -E '^([A-Za-z0-9+/=]|[\t\n\f\r ])*$' >/dev/null; then
    GIT_PROFILE_CSV_DATA=$(echo "$GIT_PROFILE_CSV_DATA" | base64 -d)
    echo "The data is decoded from base64 encoded data to plain data."
else
    echo "The data is plain (decoded) data."
fi

USER_COUNT=$(($(echo "$GIT_PROFILE_CSV_DATA" | tr -d '\r' | grep -v '^$' | wc -l) - 1))

for (( USER_NUMBER = 1; USER_NUMBER <= $USER_COUNT; USER_NUMBER++ ));
do
    USER=$(($USER_NUMBER + 1))

    PURPOSE=$(echo "$GIT_PROFILE_CSV_DATA" | awk -F',' -v user="$USER" 'NR==user {print $1}' | tr -d '\r')
    USER_NUMBER_BY_PURPOSE=$(echo "$GIT_PROFILE_CSV_DATA" | awk -F',' -v user="$USER" 'NR==user {print $2}' | tr -d '\r')
    USER_NAME=$(echo "$GIT_PROFILE_CSV_DATA" | awk -F',' -v user="$USER" 'NR==user {print $3}' | tr -d '\r')
    GIT_REPO_USER_NAME=$(echo "$GIT_PROFILE_CSV_DATA" | awk -F',' -v user="$USER" 'NR==user {print $4}' | tr -d '\r')
    GIT_REPO_USER_EMAIL=$(echo "$GIT_PROFILE_CSV_DATA" | awk -F',' -v user="$USER" 'NR==user {print $5}' | tr -d '\r')
    GIT_REPO_NAME=$(echo "$GIT_PROFILE_CSV_DATA" | awk -F',' -v user="$USER" 'NR==user {print $6}' | tr -d '\r')
    GIT_REPO_PERSONAL_TOKEN=$(echo "$GIT_PROFILE_CSV_DATA" | awk -F',' -v user="$USER" 'NR==user {print $7}' | tr -d '\r')
    
    SECRET_NAMES=("GIT_REPO_USER_NAME" "GIT_REPO_USER_EMAIL" "GIT_REPO_PERSONAL_TOKEN")

    for SECRET_NAME in "${SECRET_NAMES[@]}"; 
    do

        GIT_REPO_SECRET_NAME="${SECRET_NAME}_${PURPOSE}_${USER_NUMBER_BY_PURPOSE}"
        if ! gh secret set "$GIT_REPO_SECRET_NAME" --repo "$GIT_USER_NAME/$GIT_REPO_NAME" --body "${!SECRET_NAME}"; then
            echo "Error setting $GIT_REPO_SECRET_NAME secret."
            exit 1
        fi

        CHECK_SECRET=$(gh api "repos/$GIT_USER_NAME/$GIT_REPO_NAME/actions/secrets/$GIT_REPO_SECRET_NAME" -H "Accept: application/vnd.github.v3+json")
        while [[ $CHECK_SECRET == *"Not Found"* ]]; 
        do
            echo "$GIT_REPO_SECRET_NAME has not been created yet..."
            sleep 3  # Sleep before checking again
            CHECK_SECRET=$(gh api "repos/$GIT_USER_NAME/$GIT_REPO_NAME/actions/secrets/$GIT_REPO_SECRET_NAME" -H "Accept: application/vnd.github.v3+json")
        done
        echo "$GIT_REPO_SECRET_NAME is set as Github repository secret data."
    done

done