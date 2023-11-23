#!/usr/bin/env bash
sudo add-apt-repository ppa:git-core/ppa \
&& sudo apt update \
&& sudo apt isntall git -y


sudo cp pinentry /usr/local/bin