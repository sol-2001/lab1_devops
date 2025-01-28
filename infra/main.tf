resource "yandex_vpc_network" "default" {
  name = "default-network"
}

resource "yandex_vpc_subnet" "default" {
  name           = "default-subnet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.default.id
  v4_cidr_blocks = ["10.128.0.0/24"]
}

resource "yandex_compute_instance" "vm" {
  name = "dev-vm"

  resources {
    cores  = 4
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd82odtq5h79jo7ffss3"
      size     = 50
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.default.id
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
    source      = "/home/danil/IdeaProjects/todo-project/docker-compose-sonar.yml"
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

# Container Registry
resource "yandex_container_registry" "todo_registry" {
  name = "todo-registry"
}

# Kubernetes Cluster
resource "yandex_kubernetes_cluster" "todo_k8s_cluster" {
  name        = "todo-k8s-cluster"
  folder_id   = var.folder_id
  network_id  = yandex_vpc_network.default.id

  # Указываем сервисный аккаунт для узлов кластера
  service_account_id        = var.service_account_id
  node_service_account_id   = var.service_account_id

  master {
    version       = "1.28"
    public_ip     = true
    zonal {
      zone = "ru-central1-a"
      subnet_id = yandex_vpc_subnet.default.id
    }
    maintenance_policy {
      auto_upgrade = true
    }
  }
}

# Node Group for Kubernetes Cluster
resource "yandex_kubernetes_node_group" "todo_k8s_node_group" {
  cluster_id = yandex_kubernetes_cluster.todo_k8s_cluster.id
  name       = "todo-node-group"

  instance_template {
    platform_id = "standard-v2"
    resources {
      memory = 4
      cores  = 2
    }
    boot_disk {
      type = "network-hdd"
      size = 50
    }
    network_interface {
      subnet_ids = [yandex_vpc_subnet.default.id]
      nat        = true
    }
  }

  scale_policy {
    auto_scale {
      min = 1
      max = 5
      initial = 1
    }
  }

  allocation_policy {
    location {
      zone = "ru-central1-a"
    }
  }
}


