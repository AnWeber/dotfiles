#!/usr/bin/env bash
sudo apt update
sudo apt install unzip fontconfig -y
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.0/FiraCode.zip
unzip FiraCode.zip -d ~/.fonts
fc-cache -fv