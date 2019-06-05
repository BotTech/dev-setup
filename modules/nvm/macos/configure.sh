#!/usr/bin/env bash

mkdir -p ~/.nvm

nvm_init=$'# Initialize nvm.'\
$'export NVM_DIR="$HOME/.nvm"'\
$'[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm'\
'[ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"  # This loads nvm bash_completion'

if_command_exists bash add_to_bash_profile "${nvm_init}"
if_command_exists zsh echo 'Make sure that you add the nvm plugin to ZSH.'
