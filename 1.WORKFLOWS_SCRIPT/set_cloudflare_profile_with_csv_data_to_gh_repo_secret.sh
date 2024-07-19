#!/bin/bash

CLOUDFLARE_CSV_DATA=$CLOUDFLARE_CSV_DATA
GIT_USER=$GIT_USER
GIT_REPO=$GIT_REPO

if echo "$CLOUDFLARE_CSV_DATA" | grep -E '^([A-Za-z0-9+/=]|[\t\n\f\r ])*$' >/dev/null; then
    CLOUDFLARE_CSV_DATA=$(echo "$CLOUDFLARE_CSV_DATA" | base64 -d)
    echo "The data is decoded from base64 encoded data to plain data."
else
    echo "The data is plain (decoded) data."
fi

USER_COUNT=$(($(echo "$CLOUDFLARE_CSV_DATA" | tr -d '\r' | grep -v '^$' | wc -l) - 1))

for (( USER_NUMBER = 1; USER_NUMBER <= $USER_COUNT; USER_NUMBER++ ));
do
    USER=$(($USER_NUMBER + 1))

    CLOUDFLARE_EMAIL=$(echo "$CLOUDFLARE_CSV_DATA" | awk -F',' -v user="$USER" 'NR==user {print $1}' | tr -d '\r')
    CLOUDFLARE_API_KEY=$(echo "$CLOUDFLARE_CSV_DATA" | awk -F',' -v user="$USER" 'NR==user {print $2}' | tr -d '\r')
    CLOUDFLARE_DOMAIN=$(echo "$CLOUDFLARE_CSV_DATA" | awk -F',' -v user="$USER" 'NR==user {print $3}' | tr -d '\r')
    CLOUDFLARE_PURPOSE=$(echo "$CLOUDFLARE_CSV_DATA" | awk -F',' -v user="$USER" 'NR==user {print $4}' | tr -d '\r')

    SECRET_NAMES=("CLOUDFLARE_EMAIL" "CLOUDFLARE_API_KEY" "CLOUDFLARE_DOMAIN")

    for SECRET_NAME in "${SECRET_NAMES[@]}";
    do

        GIT_REPO_SECRET_NAME="${SECRET_NAME}_${CLOUDFLARE_PURPOSE}_${USER_NUMBER}"
        if ! gh secret set "$GIT_REPO_SECRET_NAME" --repo "$GIT_USER/$GIT_REPO" --body "${!SECRET_NAME}"; then
            echo "Error setting $GIT_REPO_SECRET_NAME secret."
            exit 1
        fi

        CHECK_SECRET=$(gh api "repos/$GIT_USER/$GIT_REPO/actions/secrets/$GIT_REPO_SECRET_NAME" -H "Accept: application/vnd.github.v3+json")
        while [[ $CHECK_SECRET == *"Not Found"* ]]; 
        do
            echo "$GIT_REPO_SECRET_NAME has not been created yet..."
            sleep 3  # Sleep before checking again
            CHECK_SECRET=$(gh api "repos/$GIT_USER/$GIT_REPO/actions/secrets/$GIT_REPO_SECRET_NAME" -H "Accept: application/vnd.github.v3+json")
        done
        echo "$GIT_REPO_SECRET_NAME is set as Github repository secret data."
    done

done