#!/usr/bin/env bash

brew tap AdoptOpenJDK/openjdk

if [[ "$1" == "8" ]]; then
  # Temporary workaround for https://github.com/AdoptOpenJDK/homebrew-openjdk/issues/106
  brew_cask_install_quiet adoptopenjdk/openjdk/adoptopenjdk8
else
  brew_cask_install_quiet "adoptopenjdk$1"
fi
