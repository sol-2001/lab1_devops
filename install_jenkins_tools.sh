#!/bin/bash

sudo apt update

sudo apt install -y openjdk-17-jdk

sudo apt install -y nodejs npm

curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash

sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release

sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
  
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt update

sudo apt install -y jenkins
