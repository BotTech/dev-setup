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

readonly config_dir="${script_dir}/../config/${os}"
readonly modules_dir="${script_dir}/../modules"
readonly modules_file="${config_dir}/modules"
readonly comment_regex="^[[:space:]]*#.*"

pm_file="${config_dir}/pm"
if [[ -f "${pm_file}" ]]; then
  pm="$( <"${pm_file}" )"
  pm_module_dir="${modules_dir}/${pm}/${os}"
fi

# Helper functions available to other scripts. This only works with bash.
# TODO: Source these as normal functions within the subshells.
source "${script_dir}/functions.shlib"
[[ ! -f "${pm_module_dir}/functions.shlib" ]] || source "${pm_module_dir}/functions.shlib"

invoke_module_script() {
  local script="$1"
  local module_name="$2"
  local module_dir="${modules_dir}/${module_name}/${os}"
  local module_script="${module_dir}/${script}"
  if [[ -f "${module_script}" ]]; then
    set +e
    (
      cd "${module_dir}"
      "${module_script}" "${@:3}"
    )
    [[ "$?" -eq 0 ]] || { 2>&1 echo "Failed!"; exit "${EXIT_MODULE_SCRIPT_FAILED}"; }
    set -e
  else
    2>&1 echo "Module ${module_name} is missing script ${script} (${module_script})."
  fi
}

invoke_pm_script() {
  local script="$1"
  if [[ -z "${pm_module_dir+x}" ]]; then
    (
      cd "${pm_module_dir}"
      "${pm_module_dir}/${script}"
    )
  fi
}

invoke_all_modules_script() {
  local script="$1"
  local message="$2"
  if [[ -f "${modules_file}" ]]; then
    local line
    while IFS='' read -r line || [[ -n "${line}" ]]; do
      line="${line#"${line%%[![:space:]]*}"}"
      line="${line%"${line##*[![:space:]]}"}"
      if [[ -n "${line}" && ! "${line}" =~ $comment_regex ]]; then
        declare -a "module_command=( ${line} )"
        printf "${message}" "${module_command[*]}"
        invoke_module_script "${script}" "${module_command[@]}"
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

configure_modules() {
  if [[ -f "${modules_file}" ]]; then
    local line
    while IFS='' read -r line || [[ -n "${line}" ]]; do
      line="${line#"${line%%[![:space:]]*}"}"
      line="${line%"${line##*[![:space:]]}"}"
      if [[ -n "${line}" && ! "${line}" =~ $comment_regex ]]; then
        declare -a "module_command=( ${line} )"
        local module_name="${module_command[0]}"
        local module_dir="${modules_dir}/${module_name}/${os}"
        local module_config_dir="${config_dir}/module-config/${module_name}"
        if [[ -f "${module_dir}/configure.sh" ]]; then
          echo "Configuring ${module_name}..."
          invoke_module_script "configure.sh" "${module_name}"
        fi
        if [[ -d "${module_config_dir}" ]]; then
          [[ -f "${module_dir}/configure.sh" ]] || echo "Configuring ${module_name}..."
          (
            cd "${module_config_dir}"
            export PATH="${PATH}:${module_dir}"
            "${module_config_dir}/configure.sh"
          )
        fi
      fi
    done < "${modules_file}"
  fi
}

case "$1" in
  ""|install)
    install_pm
    install_modules
    configure_modules
    ;;
  upgrade)
    upgrade_pm
    upgrade_modules
    ;;
  reconfigure)
    configure_modules
    ;;
  *)
    2>&1 echo "Unknown command: $1"
    exit "${EXIT_UNKNOWN_COMMAND}"
esac
