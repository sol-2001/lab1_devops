#!/bin/bash

sudo apt update

sudo apt install -y openjdk-17-jdk

sudo apt install -y nodejs npm

curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash

sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release

wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

sudo apt update

sudo apt install -y jenkins
