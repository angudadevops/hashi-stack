job "countdash3" {
  datacenters = ["us-west-1"]

  group "api" {
    network {
      mode = "bridge"
      port "http" {
        to = "9001"
      }
    }

    service {
      name = "count-api"
      port = "http"
      check {
        port = "http"
        type = "http"
        path = "/"
        interval = "5s"
        timeout = "2s"
        address_mode = "driver"
      }
      connect {
        sidecar_service {}
      }
    }

    task "web" {
      driver = "docker"

      config {
        image = "hashicorpnomad/counter-api:v1"
      }
    }
  }

  group "dashboard" {
    network {
      mode = "bridge"

      port "http" {
        static = 9002
        to     = 9002
      }
    }

    service {
      name = "count-dashboard"
      port = "9002"

      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "count-api"
              local_bind_port  = 8080
            }
          }
        }
      }
    }

    task "dashboard" {
      driver = "docker"

      env {
        COUNTING_SERVICE_URL = "http://${NOMAD_UPSTREAM_ADDR_count_api}"
      }

      config {
        image = "hashicorpnomad/counter-dashboard:v1"
      }
    }
  }
