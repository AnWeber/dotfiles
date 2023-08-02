#!/usr/bin/env bash
if ! type "docker" > /dev/null; then
  sudo apt update
  echo "update iptables to 1"
  sudo update-alternatives --config iptables
  sudo apt-get install \
      ca-certificates \
      curl \
      gnupg \
      lsb-release
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update
  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

  echo "add to visudo: $USER ALL=(ALL) NOPASSWD: /usr/bin/dockerd"
  sudo visudo
  sudo usermod -aG docker $USER
fi


