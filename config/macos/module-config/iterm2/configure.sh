#!/usr/bin/env bash

set -e

mkdir -p ~/"Library/Application Support/iTerm2/DynamicProfiles"
cp profiles.json ~/"Library/Application Support/iTerm2/DynamicProfiles/"
# TODO: Find a way to script this.
#  https://gitlab.com/gnachman/iterm2/issues/7829
echo 'Added a Dynamic Default profile to iTerm2.'
echo 'You need to set this as the Default profile and/or delete the existing Default profile.'

configure_shell_integration.sh
