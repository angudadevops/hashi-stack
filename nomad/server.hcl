# /etc/nomad.d/server.hcl

datacenter = "us-west-1"
data_dir = "/etc/nomad.d/"

server {
  enabled          = true
  bootstrap_expect = 1
}

name = "NODENAME"

bind_addr = "PRIVATEIP"

consul {
  address = "SERVERIP:8500"
}

advertise {
  http = "SERVERIP"
  rpc  = "SERVERIP"
  serf = "SERVERIP"
}
