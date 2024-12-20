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
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd82odtq5h79jo7ffss3" # ID образа Ubuntu 24.04
      size     = 20
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.default.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }

  # Команды по установке Docker через provisioner
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg",
      "echo \"deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
      "sudo apt-get update -y",
      "sudo apt-get install -y docker-ce docker-ce-cli containerd.io",
      "sudo usermod -aG docker ubuntu"
    ]

    connection {
      host        = yandex_compute_instance.vm.network_interface.0.nat_ip_address
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
    }
  }
}


resource "yandex_compute_instance" "jenkins_vm" {
  name = "jenkins-vm"
  zone = "ru-central1-a"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd82odtq5h79jo7ffss3" # Ubuntu 22.04 например
      size     = 20
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.default.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}
