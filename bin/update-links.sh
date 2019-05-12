#!/usr/bin/env bash

previous_commit=2c011cf63d9c178b93eedf8fd14fdf492f5d0d2e
latest_commit="$(git rev-parse HEAD)"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

update_links_mac() {
  sed -i "" "s/${previous_commit}/${latest_commit}/g" "${script_dir}/../README.md" "${script_dir}/update-links.sh"
}

update_links_linux() {
  sed -i "s/${previous_commit}/${latest_commit}/g" "${script_dir}/../README.md"
  sed -i "s/${previous_commit}/${latest_commit}/g" "${script_dir}/update-links.sh"
}

case "${OSTYPE}" in
  linux-gnu) update_lins_linux ;;
  darwin*) update_links_mac ;;
  *)
    >&2 echo "Unsupported operating system: ${OSTYPE}"
    exit 1
    ;;
esac

