#!/usr/bin/env bash

set -e

# Copy over the profiles.
mkdir -p ~/"Library/Application Support/iTerm2/DynamicProfiles"
cp profiles.json ~/"Library/Application Support/iTerm2/DynamicProfiles/"

configure_shell_integration.sh
