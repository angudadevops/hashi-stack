SERVER_IP=$(awk -F= '/SERVER_IP/ {print $2}' /etc/environment)
PRIVATE_IP=$(awk -F= '/PRIVATE_IP/ {print $2}' /etc/environment)
count=$(awk -F= '/count/ {print $2}' /etc/environment)
sudo mv -f /tmp/consul/client.json /etc/consul.d/client.json
sudo mv -f /tmp/consul/consul.service /etc/systemd/system/consul.service
sudo mv -f /tmp/nomad/nomad.service /etc/systemd/system/nomad.service
sudo mv -f /tmp/nomad/client.hcl /etc/nomad.d/client.hcl

sudo systemctl daemon-reload
sudo systemctl restart consul
sudo systemctl enable consul
sudo systemctl restart nomad
sudo systemctl enable nomad

sleep 10

#sudo mv -f /tmp/consul/client.json /etc/consul.d/client.json
sudo mv -f /tmp/vault/vault.service /etc/systemd/system/vault.service
#sudo mv -f /tmp/consul/consul.service /etc/systemd/system/consul.service
#sudo mv -f /tmp/nomad/nomad.service /etc/systemd/system/nomad.service
#sudo mv -f /tmp/nomad/client.hcl /etc/nomad.d/client.hcl
sudo mv -f /tmp/vault/server.hcl /etc/vault.d/server.hcl

sudo systemctl daemon-reload
sudo systemctl restart consul
sudo systemctl enable consul
sudo systemctl restart nomad
sudo systemctl enable nomad
sudo systemctl enable vault
sudo systemctl restart vault

echo -e "vagrant ssh server1\n nomad -address=http://$SERVER_IP:4646 job run /tmp/jobs/sample.nomad\n nomad -address=http://$SERVER_IP:4646 job run /tmp/jobs/python-app.nomad"

