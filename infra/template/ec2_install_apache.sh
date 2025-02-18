#!/bin/bash
# Change to the home directory
cd /home/ubuntu

# Update package list and install required packages including python3-venv
yes | sudo apt update
yes | sudo apt install python3 python3-pip python3-venv -y

# Clone the repository if it doesn't already exist
if [ ! -d "devops_app" ]; then
    git clone https://github.com/decateca/devops_app.git
fi

# Wait for 20 seconds to ensure cloning is complete
sleep 20

# Change into the project directory
cd devops_app

# Fix permissions in case previous commands used sudo (optional but recommended)
sudo chown -R ubuntu:ubuntu .

# Remove any existing virtual environment (optional, to start fresh)
rm -rf venv

# Create a virtual environment named "venv"
python3 -m venv venv

# Activate the virtual environment
source venv/bin/activate

# Install dependencies from requirements.txt in the virtual environment
pip install -r requirements.txt

echo 'Waiting for 30 seconds before running the app.py'

# Run the app in the background so it persists after logout
setsid python3 -u app.py &

# Wait for 30 seconds (or adjust as needed)
sleep 30
