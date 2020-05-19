datacenter = "us-west-1"
data_dir = "/etc/nomad.d"

client {
  enabled = true
  servers = ["SERVERIP:4647"]
}
bind_addr = "0.0.0.0" # the default
consul {
  address = "SERVERIP:8500"
}
