#!/usr/bin/env bash

jenv_init=$'# Initialize jenv.'\
$'export PATH="$HOME/.jenv/bin:$PATH"\n'\
'eval "$(jenv init -)"'

if_command_exists bash add_to_bash_profile "${jenv_init}"

# TODO: If using oh-my-zsh then add plugin.
