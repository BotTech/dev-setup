#!/usr/bin/env bash

set -e

readonly DEV_SETUP_GIT_BRANCH=master
readonly DEV_SETUP_GIT_URL=git@github.com:BotTech/dev-setup.git

readonly EXIT_CANNOT_PARSE_SSH_KEYGEN=1
readonly EXIT_GITHUB_SSH_FAILED=2

echo "Bootstrapping dev-setup..."

# Another file descriptor for standard out.
exec 3>&1

test_github_ssh() {
  echo "Testing whether we can connect to GitHub via SSH... "
  set +e
  ssh -T git@github.com
  local gitHubResponse="$?"
  set -e
  # This will be 1 if the SSH key has been configured correctly.
  # 255 means that an error occurred in SSH.
  if [[ "${gitHubResponse}" -eq 255 ]]; then
    return 1
  else
    return 0
  fi
}

generate_ssh_key() {
  local ssh_keygen_output="$(ssh-keygen -t rsa -b 4096 -C "$(whoami)@$(hostname)" | tee >(cat - >&3))"
  local regex=$'Your identification has been saved in ([^\n]+)\.'
  if [[ "${ssh_keygen_output}" =~ $regex ]]; then
    echo "${BASH_REMATCH[1]}"
    return 0
  else
    >&2 echo "Failed to parse ssh-keygen output"
    exit "${EXIT_CANNOT_PARSE_SSH_KEYGEN}"
  fi
}

get_ssh_key() {
  local private_key=~/.ssh/id_rsa
  if [[ ! -f "${private_key}" ]]; then
    private_key="$(generate_ssh_key)"
  fi
  echo "${private_key}"
  return 0
}

add_ssh_key_macos() {
  local private_key="$1"
  eval "$(ssh-agent -s)"
  cat << EOF >> ~/.ssh/config
Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ${private_key}
EOF
  ssh-add -K "${private_key}"
}

add_ssh_key_linux() {
  local private_key="$1"
  eval "$(ssh-agent -s)"
  # TODO: Check that this configuration is correct.
  cat << EOF >> ~/.ssh/config
Host *
  AddKeysToAgent yes
  IdentityFile ${private_key}
EOF
  ssh-add "${private_key}"
}

add_ssh_key_windows() {
  local private_key="$1"
  eval "$(ssh-agent -s)"
  # TODO: Check that this configuration is correct.
  cat << EOF >> ~/.ssh/config
Host *
  AddKeysToAgent yes
  IdentityFile ${private_key}
EOF
  ssh-add "${private_key}"
  # This assumes that the native SSH agent is being used and not the one from cygwin/msys.
  ssh-add "$(cygpath -w "${HOME}/.ssh/id_rsa")" 
}

add_ssh_key() {
  local private_key="$1"
  echo -n "Setting up SSH to GitHub... "
  case "${OSTYPE}" in
    linux-gnu)
      add_ssh_key_linux "${private_key}"
      echo "Success"
      ;;
    darwin*)
      add_ssh_key_macos "${private_key}"
      echo "Success"
      ;;
    cygwin|msys)
      add_ssh_key_windows "${private_key}"
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
      >&2 echo "Cannot open the web browser for your operating system (${os})."
      ;;
  esac
}

copy_to_clipboard() {
  local to_copy="$1"
  case "${OSTYPE}" in
    linux-gnu)
      # This assumes that X Window is being used.
      xclip < "${to_copy}"
      ;;
    darwin*)
      pbcopy < "${to_copy}"
      ;;
    cygwin|msys)
      clip < "${to_copy}"
      ;;
    *)
      >&2 echo "Cannot copy to the clipboard for your operating system (${os})."
      ;;
  esac
}

add_key_to_github() {
  local private_key="$1"
  local public_key="${private_key}.pub"
  copy_to_clipboard "${public_key}" && echo "Copied ${public_key} to the clipboard."
  echo "Add your SSH public key to GitHub (https://github.com/settings/keys)."
  open_browser "https://github.com/settings/keys"
  read -p "Press enter when done..."
  copy_to_clipboard /dev/null
}

setup_github_ssh() {
  echo "Setting up SSH to GitHub..."
  local private_key="$(get_ssh_key)"
  add_ssh_key "${private_key}"
  add_key_to_github "${private_key}"
  if ! test_github_ssh; then
    >&2 echo "Failed to setup SSH to connect to GitHub. Please report this issue."
    >&2 echo "In the meantime, you can workaround this by setting it up manually by following the instructions on https://help.github.com/en/articles/connecting-to-github-with-ssh"
    exit "${EXIT_GITHUB_SSH_FAILED}"
  fi
}

setup_github() {
  if ! test_github_ssh; then
    setup_github_ssh
  fi
}

clone() {
  local url="${1:-${DEV_SETUP_GIT_URL}}"
  local branch="${2:-${DEV_SETUP_GIT_BRANCH}}"
  local default_dir="$(pwd)/dev-setup"
  local dir
  read -p "Enter directory to clone to (${default_dir}): " dir
  dir="${dir:-$default_dir}"
  git clone "${url}" "${dir}" > /dev/null
  git -C "${dir}" checkout "${branch}" > /dev/null
  echo "${dir}"
}

fork() {
  local url="${1:-${DEV_SETUP_GIT_URL}}"
  echo "Fork the repository (${url})."
  open_browser "${url}"
  read -p "Press enter when done..."
  local fork_url
  read -p "Enter the SSH URL to your fork: " fork_url
  shift
  local dir
  dir="$(clone "${fork_url}" "$@")"
  bash "${dir}/bin/init-fork.sh"
}

dev_setup() {
  local dir
  dir="$(clone "${DEV_SETUP_GIT_URL}" "$@")"
  bash "${dir}/bin/dev-setup.sh"
}

setup_github

if [[ "$1" == "fork" ]]; then
  shift
  fork "$@"
elif [[ "$1" == "setup" ]]; then
  shift
  dev_setup "$@"
fi

