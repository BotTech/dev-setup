#!/usr/bin/env bash

brew tap AdoptOpenJDK/openjdk

brew_cask_install_quiet "adoptopenjdk$1"

