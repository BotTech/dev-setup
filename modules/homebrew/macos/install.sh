#!/usr/bin/env bash

# https://brew.sh/

if command -v brew >/dev/null 2>&1; then
  exit 0
fi

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

