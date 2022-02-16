
if ! command -v pip3 &> /dev/null
then
  sudo apt-get install python-pip
  pip3 install pygmentize
fi

