disableProxy() {
  if [ ! -z ${http_proxy+x} ]; then
    echo "disable proxy"
    unset http_proxy;
    unset https_proxy;
    unset HTTP_PROXY;
    unset HTTPS_PROXY;
    unset no_proxy;
    unset NO_PROXY;
  fi
}

enableProxy(){
  if [ ! -z ${http_proxy_cache+x} ]; then
    export http_proxy=$http_proxy_cache;
    export https_proxy=$http_proxy_cache;
    export HTTP_PROXY=$http_proxy_cache;
    export HTTPS_PROXY=$http_proxy_cache;
    export no_proxy=$no_proxy_cache;
    export NO_PROXY=$no_proxy_cache;
  fi
}
enableVpnProxy(){
  localProxy='192.168.2.1:8888';
  export http_proxy=$localProxy;
  export https_proxy=$localProxy;
  export HTTP_PROXY=$localProxy;
  export HTTPS_PROXY=$localProxy;
}

fixVpn(){
  sudo ifconfig eth0 mtu 1350;
  disableProxy;
}