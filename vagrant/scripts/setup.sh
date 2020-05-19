set -e

CONSUL_VERSION=1.7.3
NOMAD_VERSION=0.11.1
VAULT_VERSION=1.4.1

echo "System update..."
sudo apt update -y
echo "Installting tools.."
sudo apt install wget -y
sudo apt install curl -y
sudo apt install vim -y
sudo apt install unzip -y
sudo apt install jq -y
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   bionic \
   stable"
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo systemctl start docker
sudo systemctl enable docker

wget --quiet https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip
unzip consul_${CONSUL_VERSION}_linux_amd64.zip
sudo mv consul /usr/local/bin/
sudo groupadd --system consul
sudo useradd -s /sbin/nologin --system -g consul consul
sudo mkdir -p /var/lib/consul /etc/consul.d
sudo chown -R consul:consul /var/lib/consul /etc/consul.d
sudo chmod -R 775 /var/lib/consul /etc/consul.d
#sudo rm -rf /etc/systemd/system/consul.service
#sudo touch /etc/systemd/system/consul.service

echo "Installing NOMAD"
wget --quiet https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip
unzip nomad_${NOMAD_VERSION}_linux_amd64.zip
sudo ls -lrt
sudo mv nomad /usr/local/bin/
sudo mkdir -p /etc/nomad.d
sudo groupadd --system nomad
sudo useradd -s /sbin/nologin --system -g nomad nomad
sudo mkdir -p /var/lib/nomad /etc/nomad.d
sudo chown -R nomad:nomad /var/lib/nomad /etc/nomad.d
sudo chmod -R 775 /var/lib/nomad /etc/nomad.d

#sudo touch /etc/nomad.d/nomad.hcl
echo "Installing Vault"
sudo wget --quiet https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip
sudo unzip vault_${VAULT_VERSION}_linux_amd64.zip
sudo mv vault /usr/local/bin/
sudo rm vault_${VAULT_VERSION}_linux_amd64.zip
sudo chmod +x /usr/local/bin/vault
sudo mkdir --parents /etc/vault.d
sudo groupadd --system vault
sudo useradd -s /sbin/nologin --system -g vault vault
sudo mkdir -p /var/lib/vault /etc/vault.d
sudo chown -R vault:vault /var/lib/vault /etc/vault.d
sudo chmod -R 775 /var/lib/vault /etc/vault.d
