#!/usr/bin/env bash

brew tap caskroom/versions
brew_cask_install_quiet "java$1"
