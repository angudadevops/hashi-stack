job "http-echo-dynamic-service" {
  datacenters = ["us-west-1"]  group "echo" {
    count = 2
    task "server" {
      driver = "docker"
      config {
        image = "hashicorp/http-echo:latest"
        args  = [
          "-listen", ":${NOMAD_PORT_http}",
          "-text", "Moin ich lausche ${NOMAD_IP_http} auf Port ${NOMAD_PORT_http}",
        ]
      }      
      resources {
        network {
          mbits = 15
          port "http" {}
        }
      }     
      service {
        name = "http-echo"
        port = "http"        
        tags = [
          "vagrant",
          "urlprefix-/http-echo",
        ]        
        check {
          type     = "http"
          path     = "/health"
          interval = "2s"
          timeout  = "2s"
        }
      }
    }
  }
}
