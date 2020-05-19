count=$(awk -F= '/count/ {print $2}' /etc/environment)
echo "Recreating Nomad and Consul Services"
echo $count
sudo cp -r /tmp/hashi-ui/hashi-ui.service /etc/systemd/system/hashi-ui.service
sudo cp -r /tmp/consul/consul.service /etc/systemd/system/consul.service
sudo cp -r /tmp/consul/server.json /etc/consul.d/server.json
sudo cp -r /tmp/nomad/nomad.service /etc/systemd/system/nomad.service
sudo cp -r /tmp/nomad/server.hcl /etc/nomad.d/

sudo cat /tmp/hashi-ui/hashi-ui.service

sudo systemctl daemon-reload
sudo systemctl enable consul
sudo systemctl enable hashi-ui
sudo systemctl enable nomad

sudo systemctl restart consul
sudo systemctl restart hashi-ui
sudo systemctl restart nomad


sudo cat /etc/nomad.d/server.hcl

sleep 10

if [ $count -gt "1" ]; then
sudo mv -f /tmp/consul/servers.json /etc/consul.d/server.json
sudo mv -f /tmp/nomad/servers.hcl /etc/nomad.d/server.hcl
sudo systemctl daemon-reload
sudo systemctl enable consul
sudo systemctl enable hashi-ui
sudo systemctl enable nomad

sudo systemctl restart consul
sudo systemctl restart hashi-ui
sudo systemctl restart nomad

fi
