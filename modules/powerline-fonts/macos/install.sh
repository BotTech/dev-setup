#!/usr/bin/env bash

[[ -d ~/Library/Fonts ]] && ls ~/Library/Fonts/ | grep -qF 'Powerline' || "upgrade.sh"
