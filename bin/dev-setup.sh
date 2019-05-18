#!/usr/bin/env bash

set -e

readonly EXIT_UNKNOWN_COMMAND=1
readonly EXIT_MODULE_SCRIPT_FAILED=2

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

pm_file="${config_dir}/pm"
if [[ -f "${pm_file}" ]]; then
  pm="$(<"${pm_file}")"
  pm_module_dir="${modules_dir}/${pm}/${os}"
fi

# Helper functions available to other scripts. This only works with bash.
source "${script_dir}/functions.shlib"
[[ ! -f "${pm_module_dir}/functions.shlib" ]] || source "${pm_module_dir}/functions.shlib"

invoke_module_script() {
  local script="$1"
  local module_name="$2"
  local module_dir="${modules_dir}/${module_name}/${os}"
  local module_script="${module_dir}/${script}"
  if [[ -f "${module_script}" ]]; then
    bash "${module_script}" "${@:3}"
  else
    2>&1 echo "Module ${module_name} is missing script ${script} (${module_script})."
  fi
}

invoke_pm_script() {
  local script="$1"
  if [[ -z "${pm_module_dir+x}" ]]; then
    bash "${pm_module_dir}/${script}"
  fi
}

invoke_all_modules_script() {
  local script="$1"
  local message="$2"
  local modules_file="${config_dir}/modules"
  if [[ -f "${modules_file}" ]]; then
    local line
    while IFS='' read -r line || [[ -n "${line}" ]]; do
      line="${line#"${line%%[![:space:]]*}"}"
      line="${line%"${line##*[![:space:]]}"}"
      if [[ -n "${line}" ]]; then
        declare -a "module_command=( ${line} )"
        printf "${message}" "${module_command[*]}"
        set +e
        invoke_module_script "${script}" "${module_command[@]}"
        [[ "$?" -eq 0 ]] || { 2>&1 echo "Failed!"; exit "${EXIT_MODULE_SCRIPT_FAILED}"; }
        set -e
      fi
    done < "${modules_file}"
  fi
}

install_pm() {
  invoke_pm_script "install.sh"
}

install_modules() {
  invoke_all_modules_script "install.sh" "Installing %s...\n"
}

upgrade_pm() {
  invoke_pm_script "upgrade.sh"
}

upgrade_modules() {
  invoke_all_modules_script "upgrade.sh" "Upgrading %s...\n"
}

case "$1" in
  ""|install)
    install_pm
    install_modules
    ;;
  upgrade)
    upgrade_pm
    upgrade_modules
    ;;
  *)
    2>&1 echo "Unknown command: $1"
    exit "${EXIT_UNKNOWN_COMMAND}"
esac
