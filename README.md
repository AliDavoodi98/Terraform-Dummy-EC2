# Terraform-Dummy-EC2

## SSH to EC2
ssh -i [/dir/pemfile] ubuntu@[public-ip]

## Update and Install Required Packages:
sudo apt-get update && sudo apt-get upgrade -y
sudo apt install net-tools

## Installing HC Vault Packages
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install vault

## Enable Sudo User
sudo -i

## Enable Vault
systemctl daemon-reload
systemctl start vault
systemctl enable vault
systemctl status vault

## Configure Vault:

sudo mkdir -p /etc/vault
sudo nano /etc/vault/config.hcl