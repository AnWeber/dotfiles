#!/usr/bin/env bash

asdf plugin add jq https://github.com/AZMCode/asdf-jq.git
asdf plugin add github-cli https://github.com/bartlomiejdanek/asdf-github-cli.git
asdf plugin add mani https://github.com/anweber/asdf-mani.git

if [ -z ${ASDF_DEFAULT_TOOL_VERSIONS_FILENAME+x} ]; then
  ASDF_DEFAULT_TOOL_VERSIONS_FILENAME=".tool-versions"
fi


if grep -q "delta" "$HOME/$ASDF_DEFAULT_TOOL_VERSIONS_FILENAME"; then
  echo "delta plugin added"
  asdf plugin add delta https://github.com/andweeb/asdf-delta.git
fi


if grep -q "jira-cli" "$HOME/$ASDF_DEFAULT_TOOL_VERSIONS_FILENAME"; then
  echo "jira-cli plugin added"
  asdf plugin add jira-cli https://github.com/anweber/asdf-jira-cli.git
fi

if grep -q "bat" "$HOME/$ASDF_DEFAULT_TOOL_VERSIONS_FILENAME"; then
  echo "bat plugin added"
  asdf plugin add bat https://gitlab.com/wt0f/asdf-bat.git
fi

if grep -q "volta" "$HOME/$ASDF_DEFAULT_TOOL_VERSIONS_FILENAME"; then
  echo "volta plugin added"
  asdf plugin add volta https://github.com/anweber/asdf-volta
fi
if grep -q "java" "$HOME/$ASDF_DEFAULT_TOOL_VERSIONS_FILENAME"; then
  echo "java plugin added"
  asdf plugin add java https://github.com/halcyon/asdf-java.git
  asdf plugin add gradle https://github.com/rfrancis/asdf-gradle.git
fi
if grep -q "kubectl" "$HOME/$ASDF_DEFAULT_TOOL_VERSIONS_FILENAME"; then
  echo "kubectl plugin added"
  asdf plugin add kubectl https://github.com/asdf-community/asdf-kubectl.git
  asdf plugin add helm https://github.com/Antiarchitect/asdf-helm.git
  asdf plugin add kubectx https://github.com/virtualstaticvoid/asdf-kubectx.git
  asdf plugin add kubetail https://github.com/janpieper/asdf-kubetail.git
fi
if grep -q "glab" "$HOME/$ASDF_DEFAULT_TOOL_VERSIONS_FILENAME"; then
  echo "glab plugin added"
  asdf plugin add glab
fi

if grep -q "yq" "$HOME/$ASDF_DEFAULT_TOOL_VERSIONS_FILENAME"; then
  echo "yq plugin added"
  asdf plugin add yq
fi

if grep -q "mitmproxy" "$HOME/$ASDF_DEFAULT_TOOL_VERSIONS_FILENAME"; then
  echo "mitmproxy plugin added"
  asdf plugin add mitmproxy
fi
if grep -q "kafkactl" "$HOME/$ASDF_DEFAULT_TOOL_VERSIONS_FILENAME"; then
  echo "kafkactl plugin added"
  asdf plugin add kafkactl https://github.com/AnWeber/asdf-kafkactl
fi

if grep -q "golang" "$HOME/$ASDF_DEFAULT_TOOL_VERSIONS_FILENAME"; then
  echo "golang plugin added"
  asdf plugin add asdf-golang https://github.com/kennyp/asdf-golang.git
  asdf plugin add golangci-lint https://github.com/hypnoglow/asdf-golangci-lint.git
  asdf plugin add gofumpt
fi


if grep -q "ripgrep" "$HOME/$ASDF_DEFAULT_TOOL_VERSIONS_FILENAME"; then
  echo "ripgrep plugin added"
  asdf plugin add ripgrep
fi

if grep -q "neovim" "$HOME/$ASDF_DEFAULT_TOOL_VERSIONS_FILENAME"; then
  echo "neovim plugin added"
  asdf plugin add neovim
fi


if grep -q "eza" "$HOME/$ASDF_DEFAULT_TOOL_VERSIONS_FILENAME"; then
  echo "eza plugin added"
  asdf plugin add eza https://github.com/lwiechec/asdf-eza
fi
if grep -q "fd" "$HOME/$ASDF_DEFAULT_TOOL_VERSIONS_FILENAME"; then
  echo "fd plugin added"
  asdf plugin add fd https://gitlab.com/wt0f/asdf-fd.git
fi
if grep -q "fzf" "$HOME/$ASDF_DEFAULT_TOOL_VERSIONS_FILENAME"; then
  echo "fzf plugin added"
  asdf plugin add fzf https://github.com/kompiro/asdf-fzf.git
fi
if grep -q "zoxide" "$HOME/$ASDF_DEFAULT_TOOL_VERSIONS_FILENAME"; then
  echo "zoxide plugin added"
  asdf plugin add zoxide https://github.com/nyrst/asdf-zoxide.git
fi

if grep -q "direnv" "$HOME/$ASDF_DEFAULT_TOOL_VERSIONS_FILENAME"; then
  echo "direnv plugin added"
  asdf plugin add direnv
fi


asdf install

