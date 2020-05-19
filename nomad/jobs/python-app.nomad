job "docker-app" {
  region = "global"
  datacenters = [
    "dc1"]
  type = "service"

  group "server" {
    count = 1

    task "docker-app" {
      driver = "docker"

      constraint {
        attribute = "${attr.kernel.name}"
        value = "linux"
      }

      config {
        image = "anguda/python-flask-app:latest"
        port_map {
          python_server = 5000
        }
      }

      service {
        name = "docker-app"
        port = "python_server"

        tags = [
          "docker",
          "app"]

        check {
          type = "http"
          path = "/test"
          interval = "10s"
          timeout = "2s"
        }
      }

      resources {
        memory = 256
        network {
          mbits = 20
          port "python_server" {
          }
        }
      }

    }
  }
}
