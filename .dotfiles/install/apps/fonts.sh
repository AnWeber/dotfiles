#!/usr/bin/env bash

if ! command "fontconfig" > /dev/null; then
  echo fontconfig exists
  sudo apt update
  sudo apt install unzip fontconfig -y
fi

fontdir="$HOME/.fonts"
if [ ! -d "$fontdir" ]; then
  echo dir exists
  wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/FiraCode.zip
  unzip FiraCode.zip -d ~/.fonts
  fc-cache -fv
fi