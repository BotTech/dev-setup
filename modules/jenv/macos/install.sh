#!/usr/bin/env bash

brew_install_quiet jenv

jenv_init=$'export PATH="$HOME/.jenv/bin:$PATH"\neval "$(jenv init -)"'
add_to_bash_profile "${jenv_init}"
