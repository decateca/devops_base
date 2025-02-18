# devops-project-1

# 1. Prepare SSH Connection Between Jenkins and Flask EC2

# On Jenkins Server:
    ```bash
    # Generate SSH key pair (if not already exists)
    sudo -u jenkins ssh-keygen

    # Display public key
    sudo cat /var/lib/jenkins/.ssh/id_rsa.pub

    

# On Flask EC2:
    ```bash
    # Add Jenkins public key to authorized_keys
    echo "<PASTE_JENKINS_PUBLIC_KEY>" >> ~/.ssh/authorized_keys



# Build Steps:
    ```bash
    ssh -o StrictHostKeyChecking=no ubuntu@<FLASK_EC2_IP> "cd /home/ubuntu && ./deploy.sh"



chmod +x deploy.sh