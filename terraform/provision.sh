privateip=$(hostname -i)
SERVER_IP0=172.31.25.119
count=3
SERVER_IP1=172.31.25.211
SERVER_IP2=172.31.26.12

servers='"'$SERVER_IP0'","'$SERVER_IP1'","'$SERVER_IP2'"'

if [ -f "/etc/nomad.d/servers.hcl" ]; then
sed -ie "s/PRIVATEIP/$privateip/" /etc/nomad.d/servers.hcl
sed -ie "s/PRIVATEIP/$privateip/" /etc/consul.d/servers.json
sed -ie "s/SERVERIP/$privateip/" /etc/nomad.d/servers.hcl
sed -ie "s/SERVERIP/$privateip/" /etc/consul.d/servers.json
sed -ie "s/SERVERIP/$SERVER_IP0/" /tmp/hashi-ui.service
sed -ie "s/count/$count/" /etc/nomad.d/servers.hcl
sed -ie "s/count/$count/" /etc/consul.d/servers.json
sed -ie "s/NODENAME/$HOSTNAME/" /etc/nomad.d/servers.hcl
sed -ie "s/NODENAME/$HOSTNAME/" /etc/consul.d/servers.json

sed -ie "s/servers/$servers/" /etc/consul.d/servers.json
sed -ie "s/servers/$servers/" /etc/nomad.d/servers.hcl

sudo cp -r /etc/nomad.d/nomad.service /etc/systemd/system/nomad.service
sudo cp -r /etc/consul.d/consul.service /etc/systemd/system/consul.service

# Start Consul
systemctl daemon-reload
systemctl enable consul.service
systemctl restart consul

# Start Nomad
systemctl enable nomad.service
systemctl restart nomad

sudo cp -r /tmp/hashi-ui.service /etc/systemd/system/hashi-ui.service
systemctl daemon-reload
systemctl enable docker
systemctl restart docker
systemctl enable hashi-ui.service
systemctl restart hashi-ui
else
sed -ie "s/PRIVATEIP/$privateip/" /etc/nomad.d/client.hcl
sed -ie "s/PRIVATEIP/$privateip/" /etc/consul.d/client.json
sed -ie "s/SERVERIP/$SERVER_IP0/" /etc/consul.d/client.json
sed -ie "s/SERVERIP/$SERVER_IP0/" /etc/nomad.d/client.hcl
sed -ie "s/servers/$servers/" /etc/consul.d/client.json
sed -ie "s/NODENAME/$HOSTNAME/" /etc/consul.d/client.json

sed -ie "s/PRIVATEIP/$privateip/" /etc/vault.d/server.hcl

sudo cp -r /etc/vault.d/vault.service /etc/systemd/system/vault.service
sudo cp -r /etc/nomad.d/nomad.service /etc/systemd/system/nomad.service
sudo cp -r /etc/consul.d/consul.service /etc/systemd/system/consul.service

systemctl daemon-reload
systemctl enable consul.service
systemctl restart consul

systemctl enable vault.service
systemctl restart vault
# Start Nomad
systemctl enable nomad.service
systemctl restart nomad
fi
