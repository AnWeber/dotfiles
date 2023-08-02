
if ! command -v pip3 &> /dev/null
then
  sudo apt-get install python3-pip
  pip3 install Pygments
fi

