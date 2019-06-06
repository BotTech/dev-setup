#!/usr/bin/env bash

# TODO: This will end up conflicting with the one from antibody if it is installed that way.
# We have to remove the `env zsh -l` at the end of the script otherwise it messes everything else up for some reason.
[[ -d ~/.oh-my-zsh ]] || sh <(curl -fsSL 'https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh' | sed '/.*env zsh.*/d')
