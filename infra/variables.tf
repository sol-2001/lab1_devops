variable "folder_id" {
  description = "ID папки в Yandex Cloud"
  type        = string
  default     = "b1gtj94ev5rb7r3b7fvm"
}

variable "service_account_id" {
  description = "ID сервисного аккаунта"
  type        = string
  default     = "ajevr4dqk1dovbse8fjh"
}

variable "cloud_id" {
  description = "ID облака в Yandex Cloud"
  type        = string
  default     = "b1g81p2lg3jea5f21csl"
}

variable "service_account_key_file" {
  description = "Путь к файлу с ключом сервисного аккаунта"
  type        = string
  default     = "/home/danil/key.json"
}

