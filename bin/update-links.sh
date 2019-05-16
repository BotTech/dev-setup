#!/usr/bin/env bash

set -e

readonly PREVIOUS_REMOTE_HTTP_URL="https://github.com/BotTech/dev-setup.git"
readonly PREVIOUS_REMOTE_RAW_URL="https://raw.githubusercontent.com/BotTech/dev-setup.git"
readonly PREVIOUS_REMOTE_GIT_URL="git@github.com:BotTech/dev-setup.git"
readonly PREVIOUS_COMMIT=3497553571b3ff580478621cf278e21a1989a575

escape_slashes() {
  echo "${1//\//\\/}"
}

# Escaped
previous_remote_http_url="$(escape_slashes "${PREVIOUS_REMOTE_HTTP_URL}")"
previous_remote_raw_url="$(escape_slashes "${PREVIOUS_REMOTE_RAW_URL}")"
previous_remote_git_url="$(escape_slashes "${PREVIOUS_REMOTE_GIT_URL}")"
previous_commit="${PREVIOUS_COMMIT}"

# Not escaped
current_remote_http_url="$(git config --get remote.origin.url)"
current_remote_url="${current_remote_http_url%\.git}"

# Escaped
current_remote_http_url="$(escape_slashes "${current_remote_http_url}")"
current_remote_raw_url="${current_remote_http_url/github.com/raw.githubusercontent.com}"
current_remote_git_url="${current_remote_http_url/https:\\\/\\\/github.com\\\//git@github.com:}"
current_commit="$(git rev-parse HEAD)"

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

update_links_mac() {
  sed -i "" "s/${previous_remote_http_url}/${current_remote_http_url}/g" "${script_dir}/update-links.sh"
  sed -i "" "s/${previous_remote_raw_url}/${current_remote_raw_url}/g" "${script_dir}/update-links.sh"
  sed -i "" "s/${previous_remote_raw_url}/${current_remote_raw_url}/g" "${script_dir}/../README.md"
  sed -i "" "s/${previous_remote_git_url}/${current_remote_git_url}/g" "${script_dir}/../bootstrap.sh"
  sed -i "" "s/${previous_commit}/${current_commit}/g" "${script_dir}/../README.md"
  sed -i "" "s/${previous_commit}/${current_commit}/g" "${script_dir}/update-links.sh"
  [[ -f "${script_dir}/../TEMPLATE.md" ]] && sed -i "" "s/${previous_commit}/${current_commit}/g" "${script_dir}/../TEMPLATE.md"
}

# TODO: De-duplicate these.
update_links_linux() {
  sed -i "s/${previous_remote_http_url}/${current_remote_http_url}/g" "${script_dir}/update-links.sh"
  sed -i "s/${previous_remote_raw_url}/${current_remote_raw_url}/g" "${script_dir}/update-links.sh"
  sed -i "s/${previous_remote_raw_url}/${current_remote_raw_url}/g" "${script_dir}/../README.md"
  sed -i "s/${previous_remote_git_url}/${current_remote_git_url}/g" "${script_dir}/../bootstrap.sh"
  sed -i "s/${previous_commit}/${current_commit}/g" "${script_dir}/../README.md"
  sed -i "s/${previous_commit}/${current_commit}/g" "${script_dir}/update-links.sh"
  [[ -f "${script_dir}/../TEMPLATE.md" ]] && sed -i "s/${previous_commit}/${current_commit}/g" "${script_dir}/../TEMPLATE.md"
}

case "${OSTYPE}" in
  linux-gnu) update_lins_linux ;;
  darwin*) update_links_mac ;;
  *)
    >&2 echo "Unsupported operating system: ${OSTYPE}"
    exit 1
    ;;
esac

