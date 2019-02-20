#!/bin/bash

NIGHTBOT_STATUS=$1
NIGHTBOT_COMMAND="<command id>"

SCRIPT_DIR="/Users/noopkat/bin/twitch-scripts"
CREDS_FILE="${SCRIPT_DIR}/nightbot-creds.txt"
TOKENS_FILE="${SCRIPT_DIR}/nightbot-tokens.txt"

REFRESH_TOKEN=$(cat $TOKENS_FILE | /usr/local/bin/jq '.refresh_token' -r)
CREDS=$(cat $CREDS_FILE)

curl -X POST https://api.nightbot.tv/oauth2/token \
--silent \
-H "Content-Type: application/x-www-form-urlencoded" \
-d "${CREDS}&grant_type=refresh_token&refresh_token=${REFRESH_TOKEN}" \
-o $TOKENS_FILE

ACCESS_TOKEN=$(cat $TOKENS_FILE | /usr/local/bin/jq '.access_token' -r)

curl -X PUT "https://api.nightbot.tv/1/commands/${NIGHTBOT_COMMAND}" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  --data-urlencode "message=${NIGHTBOT_STATUS}"

