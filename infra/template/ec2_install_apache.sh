#!/bin/bash
cd /home/ubuntu

# Existing commands
yes | sudo apt update
yes | sudo apt install python3 python3-pip python3-venv -y

if [ ! -d "devops_app" ]; then
  git clone https://github.com/decateca/devops_app.git
fi

cd devops_app

# Check if requirements.txt changed
REQUIREMENTS_HASH=$(md5sum requirements.txt 2>/dev/null | cut -d' ' -f1 || echo "new")

# Pull latest changes
git checkout main
git pull origin main

NEW_REQUIREMENTS_HASH=$(md5sum requirements.txt | cut -d' ' -f1)

# Virtual environment management
if [ ! -d "venv" ] || [ "$REQUIREMENTS_HASH" != "$NEW_REQUIREMENTS_HASH" ]; then
    echo "Rebuilding virtual environment..."
    rm -rf venv
    python3 -m venv venv
    ./venv/bin/python -m pip install -r requirements.txt
else
    echo "Reusing existing virtual environment"
    ./venv/bin/python -m pip install --upgrade -r requirements.txt
fi

# Enhanced process termination
APP_PATH="/home/ubuntu/devops_app/venv/bin/python app.py"

# 1. Kill by exact process match
pkill -f "$APP_PATH" || echo "No existing process found"

# 2. Kill by port if still running
if sudo lsof -ti :5000 >/dev/null; then
    echo "Force killing processes on port 5000"
    sudo kill -9 $(sudo lsof -ti :5000)
    sleep 2  # Wait for OS to release port
fi

# 3. Verify port is free
if sudo lsof -ti :5000 >/dev/null; then
    echo "Port 5000 still in use after kill attempts"
    exit 1
fi

# Start new instance with explicit host/port
nohup $APP_PATH --host=0.0.0.0 --port=5000 > app.log 2>&1 &

# Progressive health checks
echo "Waiting for application startup..."
for i in {1..10}; do
    sleep 5
    if pgrep -f "$APP_PATH" >/dev/null; then
        echo "Application process found"
        
        # HTTP health check with retries
        if curl -sSf --retry 3 --retry-delay 2 http://localhost:5000/health >/dev/null; then
            echo "Health check successful"
            echo "Deployment completed successfully"
            exit 0
        else
            echo "Process running but health check failed"
            tail -n 20 app.log
            exit 1
        fi
    fi
done

echo "Application failed to start within 50 seconds"
tail -n 50 app.log
exit 1