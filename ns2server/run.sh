#!/usr/bin/env bash

NAME="$1"
MAP="$2"
PASSWORD="$3"
LAUNCH_CONFIG="$4"

echo "Starting server"

# Fetch config from s3 (mods, configs, etc.)
BUCKET_NAME="$(aws ssm get-parameter --name "/NS2Arena/ConfigBucket/Name")"
aws s3 sync s3://$BUCKET_NAME/$LAUNCH_CONFIG /server
PLAYER_LIMIT="$(cat /server/config.json | .PlayerLimit)"
SPEC_LIMIT="$(cat /server/config.json | .SpecLimit)"

_term() {
  echo "Caught SIGTERM, killing server"
  kill -TERM "$child" 2>/dev/null
}

trap _term SIGTERM

# /gamedata/x64/server_linux -file /server/config.txt &
/gamedata/x64/server_linux \
  -limit $PLAYER_LIMIT \
  -speclimit $SPEC_LIMIT \
  -password $PASSWORD \
  -name $NAME \
  -config_path /server/configs \
  -logdir /server/logs \
  -modstorage /server/modstore \
  -port 27015 \
  -map $MAP \
  -startmodserver
child="$!"
wait "$child"

echo "Server terminated"
