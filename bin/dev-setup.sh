#!/usr/bin/env bash

set -e

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

case "${OSTYPE}" in
  linux-gnu)
    # Distinguish between distros.
    echo TODO
    exit 1
    ;;
  darwin*)
    os="macos"
    ;;
  cygwin|msys)
    # Should we force the use of PowerShell at this point?
    echo TODO
    exit 1
    ;;
  *)
    os="${OSTYPE}"
    ;;
esac

config_dir="${script_dir}/../config/${os}"
modules_dir="${script_dir}/../modules"

# Helper functions available to install scripts.
# Only works with bash.

unless_command_exists() {
  command -v "$1" >/dev/null 2>&1 || { shift; "$@"; }
}
typeset -fx unless_command_exists

# Install the package manager.
pm_file="${config_dir}/pm"
if [[ -f "${pm_file}" ]]; then
  pm="$(<"${pm_file}")"
  pm_module_dir="${modules_dir}/${pm}/${os}"
  bash "${pm_module_dir}/install.sh"
  [[ ! -f "${pm_module_dir}/functions.shlib" ]] || source "${pm_module_dir}/functions.shlib"
fi

# Install the modulues.
modules_file="${config_dir}/modules"
if [[ -f "${modules_file}" ]]; then
  while IFS='' read -r line || [[ -n "${line}" ]]; do
    line="${line#"${line%%[![:space:]]*}"}"
    line="${line%"${line##*[![:space:]]}"}"
    if [[ -n "${line}" ]]; then
      declare -a "module_command=(${line})"
      module_name="${module_command[0]}"
      module_args=("${module_command[@]:1}")
      module_dir="${modules_dir}/${module_name}/${os}"
      bash "${module_dir}/install.sh" "${module_args[@]}"
    fi
  done < "${modules_file}"
fi

