#!/usr/bin/env bash

# TODO: Make this so that it doesn't overwrite existing plugins.
# TODO: Make adding profiles part of the built-in module configuration.
cp .zsh_plugins.txt ~/.zsh_plugins.txt
antibody bundle < ~/.zsh_plugins.txt > ~/.zsh_plugins.sh
text_to_add=$'# Antibody ZSH plugins.\n'\
'source ~/.zsh_plugins.sh'
add_to_zsh_rc 'source ~/.zsh_plugins.sh' "${text_to_add}"
