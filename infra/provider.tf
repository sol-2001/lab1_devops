terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.135.0"
    }
  }
  required_version = ">= 1.5.0"
}

provider "yandex" {
  service_account_key_file = "/home/danil/key.json"
  cloud_id  = "b1g3b76i0s0742l6fm44"
  folder_id = "b1g86p5vb1ntkb2k1877"
  zone = "ru-central1-a"
}

