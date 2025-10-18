#!/usr/bin/env bash

_term() {
  echo "Caught SIGTERM, killing server"
  kill -TERM "$child" 2>/dev/null
}

trap _term SIGTERM

echo "Starting server"
/gamedata/x64/server_linux -file /server/config.txt &
child="$!"
wait "$child"

echo "Server terminated"
