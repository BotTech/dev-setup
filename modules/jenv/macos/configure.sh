#!/usr/bin/env bash

jenv_init=$'# Initialize jenv.'\
$'export PATH="$HOME/.jenv/bin:$PATH"\n'\
'eval "$(jenv init -)"'

if_command_exists bash add_to_bash_profile "${jenv_init}"
if_command_exists zsh echo 'Make sure that you add the jenv plugin to ZSH.'

[[ -d '/Library/Java/JavaVirtualMachines' ]] && \
  find '/Library/Java/JavaVirtualMachines' -type f -path '*/Home/bin/*' -name 'java' -exec jenv add {} \;
