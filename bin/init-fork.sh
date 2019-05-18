#!/usr/bin/env bash

set -e

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

mv "${script_dir}/../TEMPLATE.md" "${script_dir}/../README.md"
bash "${script_dir}/update-links.sh"
git -C "${script_dir}/.." commit -am "Initialize fork"
