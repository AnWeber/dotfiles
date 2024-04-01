#!/usr/bin/env bash
if ! type "git" > /dev/null; then
  sudo add-apt-repository ppa:git-core/ppa \
  && sudo apt update \
  && sudo apt install git -y
fi