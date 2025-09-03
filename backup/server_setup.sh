#!/bin/bash
# A simple script to ensure the server-side components are running.

# Kill any old chisel server to ensure a clean start
pkill -f "chisel server"
echo "Old chisel processes stopped."

# Start the chisel server in the background
nohup chisel server --port 80 --reverse > /dev/null 2>&1 &
echo "Chisel server started on port 80."

# Test and restart Nginx
nginx -t
if [ $? -eq 0 ]; then
    echo "Nginx config is OK. Reloading..."
    systemctl reload nginx
else
    echo "Nginx config test failed. Please check your configuration."
fi

echo "Server setup complete."
