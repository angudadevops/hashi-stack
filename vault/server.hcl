# VAULT SERVER CONFIG

ui = "true"
cluster_name = "us-west-1"

storage "consul" {
  address = "127.0.0.1:8500"
  path    = "vault/"
}

listener "tcp" {
  address     = "0.0.0.0:8200"
  cluster_address  = "PRIVATEIP:8201"
  tls_disable = "true"
}

api_addr = "http://PRIVATEIP:8200"
cluster_addr = "https://PRIVATEIP:8201"

