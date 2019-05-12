#!/usr/bin/env bash

set -e

readonly EXIT_CANNOT_PARSE_SSH_KEYGEN=1

echo "Bootstrapping dev-setup..."

test_github_ssh() {
  echo -n "Testing whether we can connect to GitHub via SSH... "
  set +e
  ssh -T git@github.com
  local gitHubResponse="$?"
  set -e
  # This will be 1 if the SSH key has been configured correctly.
  # 255 means that an error occurred in SSH.
  if [[ "${gitHubResponse}" -eq 255 ]]; then
    echo "Failed"
    return 1
  else
    echo "Success"
    return 0
  fi
}

generate_ssh_key() {
  local ssk_keygen_output="$(ssh-keygen -t rsa -b 4096 -C "$(whoami)@$(hostname)" | grep "")"
  local regex="Your identification has been saved in ([^\n]+)\."
  if [[ "$ssk_keygen_output" =~ $regex ]]; then
    echo "${BASH_REMATCH[1]}"
    return 0
  else
    >&2 echo "Failed to parse ssh-keygen output"
    exit EXIT_CANNOT_PARSE_SSH_KEYGEN
  fi
}

get_ssh_key() {
  local private_key="~/.ssh/id_rsa"
  if [[ ! -f "$private_key" ]]; then
    private_key="$(generate_ssh_key)"
  fi
  echo "$private_key"
  return 0
}

add_ssh_key_macos() {
  local private_key="$1"
  local public_key="${private_key}.pub"
  eval "$(ssh-agent -s)"
  cat << EOF > "~/.ssh/config"
Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile $public_key
EOF
  ssh-add -K "$private_key"
}

add_ssh_key_linux() {
  local private_key="$1"
  local public_key="${private_key}.pub"
  eval "$(ssh-agent -s)"
  # TODO: Check that this configuration is correct.
  cat << EOF > "~/.ssh/config"
Host *
  AddKeysToAgent yes
  IdentityFile $public_key
EOF
  ssh-add "$private_key"
}

add_ssh_key_windows() {
  local private_key="$1"
  local public_key="${private_key}.pub"
  eval "$(ssh-agent -s)"
  # TODO: Check that this configuration is correct.
  cat << EOF > "~/.ssh/config"
Host *
  AddKeysToAgent yes
  IdentityFile $public_key
EOF
  ssh-add "$private_key"
  # This assumes that the native SSH agent is being used and not the one from cygwin/msys.
  ssh-add "$(cygpath -w "${HOME}/.ssh/id_rsa")" 
}

add_ssh_key() {
  local private_key="$1"
  echo -n "Setting up SSH to GitHub... "
  case "${OSTYPE}" in
    linux-gnu)
      add_ssh_key_linux
      echo "Success"
      ;;
    darwin*)
      add_ssh_key_macos
      echo "Success"
      ;;
    cygwin|msys)
      add_ssh_key_windows
      echo "Success"
      ;;
    *)
      echo "Failed"
      >&2 echo "Cannot add SSH key automatically for your operating system (${os})."
      ;;
  esac
}

open_browser() {
  local url="$1"
  case "${OSTYPE}" in
    linux-gnu)
      xdg-open "${url}" || gnome-open "${url}"
      ;;
    darwin*)
      open "${url}"
      ;;
    cygwin|msys)
      explorer "${url}"
      ;;
    *)
      echo "Failed"
      >&2 echo "Cannot open the web browser for your operating system (${os})."
      ;;
  esac
}

add_key_to_github() {
  local private_key="$1"
  local public_key="${private_key}.pub"
  clip < "$public_key" && echo "Copied $public_key to the clipboard."
  echo "Add your SSH public key to GitHub (https://github.com/settings/keys)."
  open_browser "https://github.com/settings/keys"
  read -p "Press enter when done..."
}

setup_github_ssh() {
  echo "Setting up SSH to GitHub..."
  local private_key="$(get_ssh_key)"
  add_ssh_key "$private_key"
  add_key_to_github "$private_key"
  if ! test_github_ssh; then
    >&2 echo "Failed to setup SSH to connect to GitHub. Please report this issue."
    >&2 echo "In the meantime, you can workaround this by setting it up manually by following the instructions on https://help.github.com/en/articles/connecting-to-github-with-ssh"
  fi
}

setup_github() {
  if ! test_github_ssh; then
    setup_github_ssh
  fi
}

setup_github()
