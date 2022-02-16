#!/usr/bin/env bash
if [ ! -d $HOME/.asdf ]; then
  git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf
  . $HOME/.asdf/asdf.sh
  asdf plugin-add jq https://github.com/AZMCode/asdf-jq.git
  asdf plugin-add github-cli https://github.com/bartlomiejdanek/asdf-github-cli.git
  asdf plugin add mani https://github.com/anweber/asdf-mani.git
  asdf install --add
fi

if [ -z ${ASDF_DEFAULT_TOOL_VERSIONS_FILENAME+x} ]; then
  ASDF_DEFAULT_TOOL_VERSIONS_FILENAME=".tools-versions"
fi

if [ ! -z ${ASDF_FEATURES+x} ]; then
  asdfPlugins=$(asdf plugin list)
  if grep -q "nodejs" "$HOME/$ASDF_DEFAULT_TOOL_VERSIONS_FILENAME" && [[ ! "${asdfPlugins[*]}" =~ "nodejs" ]]; then
    echo "NodeJS install"
    asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
    asdf install
  fi
  if grep -q "java" "$HOME/$ASDF_DEFAULT_TOOL_VERSIONS_FILENAME" && [[ ! "${asdfPlugins[*]}" =~ "java" ]]; then
    echo "java install"
    asdf plugin-add java https://github.com/halcyon/asdf-java.git
    asdf plugin-add gradle https://github.com/rfrancis/asdf-gradle.git
    asdf install
  fi
  if grep -q "kubectl" "$HOME/$ASDF_DEFAULT_TOOL_VERSIONS_FILENAME" && [[ ! "${asdfPlugins[*]}" =~ "kubectl" ]]; then
    echo "kubectl install"
    asdf plugin-add kubectl https://github.com/asdf-community/asdf-kubectl.git
    asdf plugin-add helm https://github.com/Antiarchitect/asdf-helm.git
    asdf plugin-add kubectx https://github.com/virtualstaticvoid/asdf-kubectx.git
    asdf plugin-add kubetail https://github.com/janpieper/asdf-kubetail.git
    asdf install
  fi
  if grep -q "glab" "$HOME/$ASDF_DEFAULT_TOOL_VERSIONS_FILENAME" && [[ ! "${asdfPlugins[*]}" =~ "glab" ]]; then
    echo "glab install"
    asdf plugin add glab
  fi
  if grep -q "mitmproxy" "$HOME/$ASDF_DEFAULT_TOOL_VERSIONS_FILENAME" && [[ ! "${asdfPlugins[*]}" =~ "mitmproxy" ]]; then
    echo "mitmproxy install"
    asdf plugin add mitmproxy
    asdf install
  fi
  if grep -q "kafkactl" "$HOME/$ASDF_DEFAULT_TOOL_VERSIONS_FILENAME" && [[ ! "${asdfPlugins[*]}" =~ "kafkactl" ]]; then
    echo "kafkactl install"
    asdf plugin add kafkactl https://github.com/AnWeber/asdf-kafkactl
    asdf install
  fi

  if grep -q "golang" "$HOME/$ASDF_DEFAULT_TOOL_VERSIONS_FILENAME" && [[ ! "${asdfPlugins[*]}" =~ "golang" ]]; then
    echo "gloang install"
    asdf plugin add asdf-golang https://github.com/kennyp/asdf-golang.git
    asdf install
  fi
fi
