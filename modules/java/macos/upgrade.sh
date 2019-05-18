#!/usr/bin/env bash

brew tap caskroom/versions
brew_cask_install_or_upgrade "java$1"
