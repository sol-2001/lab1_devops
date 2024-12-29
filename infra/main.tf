resource "yandex_vpc_network" "default1" {
  name = "default1-network"
}

resource "yandex_vpc_subnet" "default1" {
  name           = "default1-subnet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.default1.id
  v4_cidr_blocks = ["10.128.0.0/24"]
}

resource "yandex_compute_instance" "vm" {
  name = "dev-vm"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd82odtq5h79jo7ffss3"
      size     = 20
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.default1.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }

  provisioner "file" {
    source      = "/home/danil/key.json"
    destination = "/home/ubuntu/service-account-key.json"

    connection {
      host        = self.network_interface[0].nat_ip_address
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
    }
  }
  
    provisioner "file" {
    source      = "/home/danil/IdeaProjects/todo-project/install_jenkins_tools.sh"
    destination = "/home/ubuntu/install_jenkins_tools.sh"

    connection {
      host        = self.network_interface[0].nat_ip_address
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
    }
  }

   provisioner "file" {
    source      = "/home/danil/IdeaProjects/todo-project/docker-compose.yml"
    destination = "/home/ubuntu/docker-compose.yml"

    connection {
      host        = self.network_interface[0].nat_ip_address
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
    }
  }

  provisioner "file" {
    source      = "/home/danil/IdeaProjects/todo-project/install_dev_tools.sh"
    destination = "/home/ubuntu/install_dev_tools.sh"

    connection {
      host        = self.network_interface[0].nat_ip_address
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
    }
  }
  provisioner "file" {
    source      = "/home/danil/IdeaProjects/todo-project/install_docker.sh"
    destination = "/home/ubuntu/install_docker.sh"

    connection {
      host        = self.network_interface[0].nat_ip_address
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
    }
  }  
 
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/install_docker.sh",
      "sudo /home/ubuntu/install_docker.sh"
    ]

    connection {
      host        = self.network_interface[0].nat_ip_address
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
    }
  } 
}

