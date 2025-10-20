#!/usr/bin/env bash

_term() {
  echo "Caught SIGTERM, killing server"
  kill -TERM "$child" 2>/dev/null
}

trap _term SIGTERM

echo "Starting server"

# Fetch config from s3 (mods, configs, etc.)
aws s3 sync $S3_BASE/launch_configs/$LAUNCH_CONFIG /server
PLAYER_LIMIT="$(cat /server/config.json | .PlayerLimit)"
SPEC_LIMIT="$(cat /server/config.json | .SpecLimit)"

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
