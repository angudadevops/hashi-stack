# /etc/nomad.d/server.hcl

datacenter = "us-west-1"
data_dir = "/etc/nomad.d/"

server {
  enabled          = true
  bootstrap_expect = count
  server_join {
    retry_join = [ servers ]
    retry_max = 3
    retry_interval = "15s"
  }
}

bind_addr = "PRIVATEIP"

name = "NODENAME"

consul {
  address = "SERVERIP:8500"
}

advertise {
  http = "SERVERIP"
  rpc  = "SERVERIP"
  serf = "SERVERIP"
}
