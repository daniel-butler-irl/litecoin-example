#!/usr/bin/env bash

# Making an assumption that new outbound peers connected is when the service has properly started
# Also adding the requirement that a minimum of 3 peers are required
# Convoluted solution to meet the spec this is not how I would do it in production....
if grep "New outbound peer connected:" < "${HOME}/.litecoin/debug.log" | tr "[:lower:]" "[:upper:]" | awk '$9 ~ /PEER=3/ { print }' | grep .;then
  echo "3 Peers connected ready!"
  exit 0
else
  echo "Not enough peers not ready!"
  exit 1
fi
