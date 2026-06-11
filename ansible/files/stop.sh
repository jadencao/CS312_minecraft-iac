#!/bin/bash
# Send the in-game stop command to the Minecraft console via screen.
# This saves the world and shuts the server down cleanly.
screen -S minecraft -X stuff "stop$(printf '\r')"

# Wait until the Java process actually exits before systemd considers us stopped
while pgrep -u ubuntu -f server.jar > /dev/null; do
  sleep 1
done