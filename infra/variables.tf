variable "folder_id" {
  description = "ID папки в Yandex Cloud"
  type        = string
}

variable "service_account_id" {
  description = "ID сервисного аккаунта"
  type        = string
}

variable "cloud_id" {
  description = "ID облака в Yandex Cloud"
  type        = string
}

variable "service_account_key_file" {
  description = "Путь к файлу с ключом сервисного аккаунта"
  type        = string
  default     = "/home/danil/key.json"
}

