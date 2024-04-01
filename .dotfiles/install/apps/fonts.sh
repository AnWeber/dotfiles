#!/usr/bin/env bash

if ! type "fontconfig" > /dev/null; then
  sudo apt update
  sudo apt install unzip fontconfig -y
  wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.0/FiraCode.zip
  unzip FiraCode.zip -d ~/.fonts
  fc-cache -fv
fi

if [ ! -d ~/.fonts ]; then
  wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/FiraCode.zip
  unzip FiraCode.zip -d ~/.fonts
  fc-cache -fv
fi