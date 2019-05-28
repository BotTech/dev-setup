#!/usr/bin/env bash

set -e

# Copy over the profiles.
mkdir -p ~/"Library/Application Support/iTerm2/DynamicProfiles"
cp profiles.json ~/"Library/Application Support/iTerm2/DynamicProfiles/"

add_shell_integration() {
  local shell="$1"
  local add_function="$2"
  local url="https://iterm2.com/misc/${shell}_startup.in"
  local script_name=".iterm2_shell_integration.${shell}"
  local text_to_add=$'# iTerm2 Shell Integration.\n'\
$'# This should go at the end.\n'\
'test -e "${HOME}/'"${script_name}"'" && source "${HOME}/'"${script_name}"'"'
  text_to_add="${3:-${text_to_add}}"
  if_command_exists "${shell}" curl -fsSL "${url}" > ~/"${script_name}"
  if_command_exists "${shell}" "${add_function}" "iterm2_shell_integration" "${text_to_add}"
}

add_shell_integration tcsh add_to_tcsh_login
add_shell_integration zsh add_to_zsh_rc
add_shell_integration bash add_to_bash_profile

# Fish is just difficult...
fish_text_to_add=$'# iTerm2 Shell Integration.\n'\
$'# This should go at the end.\n'\
'test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish'

add_shell_integration fish add_to_fish_config $'\n# iTerm Shell Integration added by dev-setup. This should go last.\ntest -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish'
