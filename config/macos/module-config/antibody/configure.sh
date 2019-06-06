#!/usr/bin/env bash

# TODO: Make this so that it doesn't overwrite existing plugins.
# TODO: Make adding profiles part of the built-in module configuration.
cp .zsh_plugins.txt ~/.zsh_plugins.txt
antibody bundle < ~/.zsh_plugins.txt > ~/.zsh_plugins.sh

# TODO: This should only be added if using oh-my-zsh.
# TODO: This has to come before the source below.
omz='export ZSH="$(antibody home)/https-COLON--SLASH--SLASH-github.com-SLASH-robbyrussell-SLASH-oh-my-zsh"'
add_to_zsh_rc "${omz}" "${omz}"

text_to_add=$'# Antibody ZSH plugins.\n'\
'source ~/.zsh_plugins.sh'
add_to_zsh_rc 'source ~/.zsh_plugins.sh' "${text_to_add}"

# TODO: Add these

## Fix zsh-autosuggestion
#bindkey "^[B" backward-word
#bindkey "^[F" forward-word

## Fix history-substring-search
## bind UP and DOWN arrow keys (compatibility fallback
## for Ubuntu 12.04, Fedora 21, and MacOSX 10.9 users)
#bindkey '^[[A' history-substring-search-up
#bindkey '^[[B' history-substring-search-down
#
## bind P and N for EMACS mode
#bindkey -M emacs '^P' history-substring-search-up
#bindkey -M emacs '^N' history-substring-search-down
#
## bind k and j for VI mode
#bindkey -M vicmd 'k' history-substring-search-up
#bindkey -M vicmd 'j' history-substring-search-down
