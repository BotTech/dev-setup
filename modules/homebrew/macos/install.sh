#!/usr/bin/env bash

unless_command_exists brew /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
