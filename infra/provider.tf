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
  cloud_id  = "b1g81p2lg3jea5f21csl"
  folder_id = "b1gtj94ev5rb7r3b7fvm"
  zone = "ru-central1-a"
}

