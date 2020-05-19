PRIVATE_IP=$(awk -F= '/PRIVATE_IP/ {print $2}' /etc/environment)
SERVER_IP=$(awk -F= '/SERVER_IP/ {print $2}' /etc/environment)
NODE_NAME=$(awk -F= '/NODE_NAME/ {print $2}' /etc/environment)
count=$(awk -F= '/count/ {print $2}' /etc/environment)
echo $PRIVATE_IP
echo $SERVER_IP
echo $NODE_NAME
echo $count

SERVER=$(cat /tmp/server)
echo "Generating IP list for master server"
ip0=$(echo $SERVER | awk -F'.' '{print $4}')
ip1=$(echo $SERVER | awk -F'.' '{print $1"."$2"."$3}')
i=0
ips=$(while [ $count -gt "$i" ]
do
  ip=$(echo "$ip1.$((ip0 + i))")
  echo $ip
  let i++
done)
lists=( $ips )

declare -a nodeips=()
for item in "${lists[@]}"
do
        nodeips+=("'$item'")
        done
servers=$(echo ${nodeips[@]} | sed  "s/ /,/g;s/'/\"/g")
echo $servers

sudo cp -r /vagrant/consul /tmp/
sudo cp -r /vagrant/nomad /tmp/
sudo cp -r /vagrant/vault /tmp/
sudo cp -r /vagrant/hashi-ui /tmp/

sudo mkdir -p /etc/consul.d
sudo mkdir -p /etc/nomad.d
sudo mkdir -p /etc/vault.d

sudo chmod 755 /etc/nomad.d
sudo chmod 755 /etc/consul.d
sudo chmod 755 /etc/vault.d

sudo ls -lrt /tmp/

sed -ie "s/servers/$servers/" /tmp/consul/client.json
sed -ie "s/servers/$servers/" /tmp/consul/servers.json
sed -ie "s/servers/$servers/" /tmp/nomad/servers.hcl

sed -ie "s/NODENAME/$NODE_NAME/" /tmp/consul/client.json
sed -ie "s/NODENAME/$NODE_NAME/" /tmp/consul/server.json
sed -ie "s/NODENAME/$NODE_NAME/" /tmp/consul/servers.json
sed -ie "s/NODENAME/$NODE_NAME/" /tmp/nomad/server.hcl
sed -ie "s/NODENAME/$NODE_NAME/" /tmp/nomad/servers.hcl
sed -ie "s/NODENAME/$NODE_NAME/" /tmp/nomad/client.hcl

sed -ie "s/PRIVATEIP/$PRIVATE_IP/" /tmp/consul/client.json
sed -ie "s/PRIVATEIP/$PRIVATE_IP/" /tmp/consul/server.json
sed -ie "s/PRIVATEIP/$PRIVATE_IP/" /tmp/consul/servers.json
sed -ie "s/PRIVATEIP/$PRIVATE_IP/" /tmp/nomad/server.hcl
sed -ie "s/PRIVATEIP/$PRIVATE_IP/" /tmp/nomad/servers.hcl
sed -ie "s/PRIVATEIP/$PRIVATE_IP/" /tmp/vault/server.hcl

sed -ie "s/SERVERIP/$SERVER_IP/" /tmp/nomad/client.hcl
sed -ie "s/SERVERIP/$SERVER/" /tmp/nomad/server.hcl
sed -ie "s/SERVERIP/$SERVER_IP/" /tmp/nomad/servers.hcl
sed -ie "s/SERVERIP/$SERVER/" /tmp/hashi-ui/hashi-ui.service

sed -ie "s/count/$count/" /tmp/nomad/servers.hcl
sed -ie "s/count/$count/" /tmp/consul/servers.json
