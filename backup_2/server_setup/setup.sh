#!/bin/bash
# A simple script to ensure the server-side components are running.

echo "--> Stopping any old chisel processes..."
pkill -f "chisel server"

echo "--> Starting new chisel server on port 80..."
nohup chisel server --port 80 --reverse > /dev/null 2>&1 &

sleep 1 # Give it a moment to start

ps aux | grep '[c]hisel'

echo "
--> Testing and reloading Nginx..."
nginx -t
if [ $? -eq 0 ]; then
    echo "Nginx config is OK. Reloading..."
    systemctl reload nginx
else
    echo "Nginx config test failed! Please check your configuration."
    exit 1
fi

echo "
Server setup complete."
