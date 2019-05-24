#!/usr/bin/env bash

set -e

readonly PREVIOUS_REMOTE_HTTP_URL="https://github.com/BotTech/dev-setup.git"
readonly PREVIOUS_COMMIT=1f80ae68e0e602967406cf51be2ee7c83eb4a1a5

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

escape_slashes() {
  echo "${1//\//\\/}"
}

previous_remote_url="${PREVIOUS_REMOTE_HTTP_URL}"
previous_remote_http_url="${previous_remote_url%\.git}"
previous_remote_http_url="$(escape_slashes "${previous_remote_http_url}")"
previous_remote_raw_url="${previous_remote_http_url/github\.com/raw.githubusercontent\.com}"
previous_remote_git_url="${previous_remote_http_url/https:\\\/\\\/github\.com\\\//git@github\.com:}\.git"
previous_commit="${PREVIOUS_COMMIT}"

current_remote_url="$(git -C "${script_dir}/.." config --get remote.origin.url)"
current_remote_http_url="${current_remote_url%\.git}"
current_remote_http_url="${current_remote_http_url/git@github\.com:/https://github.com/}"
current_remote_http_url="$(escape_slashes "${current_remote_http_url}")"
current_remote_raw_url="${current_remote_http_url/github\.com/raw.githubusercontent.com}"
current_remote_git_url="${current_remote_http_url/https:\\\/\\\/github\.com\\\//git@github.com:}.git"
current_commit="$(git -C "${script_dir}" rev-parse HEAD)"

update_links_mac() {
  sed -i "" "s/${previous_remote_http_url}/${current_remote_http_url}/g" "${script_dir}/update-links.sh"
  sed -i "" "s/${previous_remote_http_url}/${current_remote_http_url}/g" "${script_dir}/bootstrap.sh"
  sed -i "" "s/${previous_remote_raw_url}/${current_remote_raw_url}/g" "${script_dir}/update-links.sh"
  sed -i "" "s/${previous_remote_raw_url}/${current_remote_raw_url}/g" "${script_dir}/../README.md"
  sed -i "" "s/${previous_remote_git_url}/${current_remote_git_url}/g" "${script_dir}/bootstrap.sh"
  sed -i "" "s/${previous_commit}/${current_commit}/g" "${script_dir}/../README.md"
  sed -i "" "s/${previous_commit}/${current_commit}/g" "${script_dir}/update-links.sh"
  [[ ! -f "${script_dir}/../TEMPLATE.md" ]] || sed -i "" "s/${previous_commit}/${current_commit}/g" "${script_dir}/../TEMPLATE.md"
}

# TODO: De-duplicate these.
update_links_linux() {
  sed -i "s/${previous_remote_http_url}/${current_remote_http_url}/g" "${script_dir}/update-links.sh"
  sed -i "s/${previous_remote_http_url}/${current_remote_http_url}/g" "${script_dir}/bootstrap.sh"
  sed -i "s/${previous_remote_raw_url}/${current_remote_raw_url}/g" "${script_dir}/update-links.sh"
  sed -i "s/${previous_remote_raw_url}/${current_remote_raw_url}/g" "${script_dir}/../README.md"
  sed -i "s/${previous_remote_git_url}/${current_remote_git_url}/g" "${script_dir}/bootstrap.sh"
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
