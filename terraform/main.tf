provider "aws" {
  access_key= var.access_key
  secret_key= var.secret_key
  region= var.region
}

resource "aws_instance" "master" {
  ami= var.ami
  key_name= var.key_name
  instance_type= var.master_instance_type
  associate_public_ip_address = true
  count = var.master_count
  tags = {
    Name = "${var.master_tags}-${count.index}"
  }
  connection {
    host = self.public_ip
    user = "ubuntu"
    type = "ssh"
    private_key = file(var.private_key_path)
    timeout = "1m"
  }
  provisioner "local-exec" {
    command = "sed -ie '/SERVER_IP${count.index}=.*/d' provision.sh"
  }
  provisioner "local-exec" {
    command = "sed -ie '/SERVER_IP${count.index}=.*/d' iplist"
  }
  provisioner "local-exec" {
    command = "sed -ie '/count=.*/d' iplist"
  }
  provisioner "local-exec" {
    command = "echo count=${var.master_count} >> iplist"
  }
  provisioner "local-exec" {
    command = "echo SERVER_IP${count.index}=${self.private_ip} >> iplist"
 }
  provisioner "local-exec" {
    command = "sed -ie '/privateip=.*/r iplist' provision.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /etc/nomad.d",
      "sudo mkdir -p /etc/consul.d",
      "sudo mkdir -p /etc/vault.d",
      "sudo chmod 777 /etc/nomad.d",
      "sudo chmod 777 /etc/consul.d",
      "sudo chmod 777 /etc/vault.d",
    ]
  }
  provisioner "file" {
      source      = "../nomad/servers.hcl"
      destination = "/etc/nomad.d/servers.hcl"
    }
  provisioner "file" {
      source      = "../nomad/nomad.service"
      destination = "/etc/nomad.d/nomad.service"
    }
  provisioner "file" {
      source      = "../consul/servers.json"
      destination = "/etc/consul.d/servers.json"
    }
  provisioner "file" {
      source      = "../consul/consul.service"
      destination = "/etc/consul.d/consul.service"
    }
  provisioner "file" {
      source      = "provision.sh"
      destination = "/home/ubuntu/provision.sh"
    }
  provisioner "file" {
      source      = "../hashi-ui/hashi-ui.service"
      destination = "/tmp/hashi-ui.service"
    }
  provisioner "remote-exec" {
    inline = [
      "chmod a+x /home/ubuntu/provision.sh",
      "sudo /home/ubuntu/provision.sh",
    ]
  }
}


resource "aws_instance" "worker" {
  ami= var.ami
  key_name= var.key_name
  instance_type= var.node_instance_type
  associate_public_ip_address = true
  count = var.worker_count
  tags = {
    Name = "${var.worker_tags}-${count.index}"
  }
  provisioner "local-exec" {
    command = "echo The server IP address is ${self.private_ip}"
  }
  connection {
    host = self.public_ip
    user = "ubuntu"
    type = "ssh"
    private_key = file(var.private_key_path)
    timeout = "1m"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /etc/nomad.d",
      "sudo mkdir -p /etc/consul.d",
      "sudo mkdir -p /etc/vault.d",
      "sudo chmod 777 /etc/nomad.d",
      "sudo chmod 777 /etc/consul.d",
      "sudo chmod 777 /etc/vault.d",
    ]
  }
  provisioner "file" {
      source      = "../nomad/client.hcl"
      destination = "/etc/nomad.d/client.hcl"
    }
  provisioner "file" {
      source      = "../nomad/nomad.service"
      destination = "/etc/nomad.d/nomad.service"
    }
  provisioner "file" {
      source      = "../consul/client.json"
      destination = "/etc/consul.d/client.json"
    }
  provisioner "file" {
      source      = "../consul/consul.service"
      destination = "/etc/consul.d/consul.service"
    }
  provisioner "file" {
      source      = "../vault/vault.service"
      destination = "/etc/vault.d/vault.service"
    }
  provisioner "file" {
      source      = "../vault/server.hcl"
      destination = "/etc/vault.d/server.hcl"
    }  
  provisioner "file" {
      source      = "provision.sh"
      destination = "/home/ubuntu/provision.sh"
    }

  provisioner "remote-exec" {
    inline = [
      "chmod a+x /home/ubuntu/provision.sh",
      "sudo /home/ubuntu/provision.sh",
    ]
  }
}
