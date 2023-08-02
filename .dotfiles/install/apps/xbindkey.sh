if ! command -v xbindkeys &> /dev/null
then
  sudo apt-get install xbindkeys xvkbd
  xbindkeys -f ~/.xbindkeysrc
fi
