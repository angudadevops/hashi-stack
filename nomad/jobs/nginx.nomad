job "nginx" {
  region = "eu"
  datacenters = ["us-west-1"]

  group "webserver" {
    count = 4

    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"

      mode = "delay"
    }

    task "nginx" {
      driver = "docker"

      config {
        image = "nginx:latest"
        port_map {
          web = 80
        }
      }

      service {
        name = "nginx"
        port = "web"
        check {
          name = "alive"
          type = "tcp"
          interval = "10s"
          timeout = "2s"
        }
      }

      resources {
        cpu = 500 # 500 Mhz
        memory = 64 # 64MB
        network {
          mbits = 10
          port "web" {
          }
        }
      }
    }
  }
}
