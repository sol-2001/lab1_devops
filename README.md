Проект представляет собой инфраструктуру и CI/CD-пайплайн для развертывания веб-приложения "To-Do List" на Yandex Cloud 
с использованием Terraform, Kubernetes, Docker, и Jenkins. Приложение состоит из фронтенда (React), бэкенда (Spring Boot)
и базы данных (PostgreSQL), с возможностью анализа кода через SonarQube

## Основные компоненты:
### Инфраструктура (Terraform):
  - Создаёт VPC, подсеть, виртуальную машину (4 ядра, 8 ГБ ОЗУ, 50 ГБ диск) с Ubuntu, контейнерный реестр и кластер Kubernetes (автообновление, 1–5 узлов).
  - Настраивает SSH-доступ и передаёт файлы (скрипты, Docker Compose, ключи) на ВМ.
  - Скрипты устанавливают Docker, Java, Node.js, Jenkins и Yandex Cloud CLI.

### Backend (Spring Boot):
  - REST API для управления задачами (CRUD)
  - Используется PostgreSQL
  - Конфигурация через application.properties

### Frontend (React):
  - Веб-интерфейс, взаимодействует с бэкендом через API
  - Деплоится как Docker-образ на базе Nginx

### CI/CD (Jenkins):
  - Пайплайн тестирует фронтенд и бэкенд, анализирует код в SonarQube, проверяет Quality Gate
  - Собирает и публикует Docker-образы в Yandex Container Registry
  - Разворачивает приложение в Kubernetes

### Kubernetes:
  - Разворачивает бэкенд, фронтенд и PostgreSQL как Deployment с LoadBalancer-сервисами.
  - Использует HorizontalPodAutoscaler (1–5 реплик, 15% CPU).
Публикуются в Yandex Container Registry.

