#!/usr/bin/env bash

set -e

readonly EXIT_UNKNOWN_COMMAND=1
readonly EXIT_MODULE_SCRIPT_FAILED=2

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

case "${OSTYPE}" in
  linux-gnu)
    # Distinguish between distros.
    echo TODO
    exit 1
    ;;
  darwin*)
    readonly OS="macos"
    ;;
  cygwin|msys)
    # Should we force the use of PowerShell at this point?
    echo TODO
    exit 1
    ;;
  *)
    readonly OS="${OSTYPE}"
    ;;
esac

readonly ROOT_DIR="${SCRIPT_DIR}/.."
readonly CONFIG_DIR="${ROOT_DIR}/config/${OS}"
readonly MODULES_DIR="${ROOT_DIR}/modules"
readonly MODULES_FILE="${CONFIG_DIR}/modules"
readonly MODULES_CONFIG_DIR="${CONFIG_DIR}/module-config"
readonly CUSTOM_MODULES_DIR="${ROOT_DIR}/custom-modules"
readonly CUSTOM_MODULES_FILE="${CONFIG_DIR}/custom-modules"
readonly CUSTOM_MODULES_CONFIG_DIR="${CONFIG_DIR}/custom-module-config"
readonly COMMENT_REGEX="^[[:space:]]*#.*"

readonly PM_FILE="${CONFIG_DIR}/pm"
if [[ -f "${PM_FILE}" ]]; then
  readonly PM="$( <"${PM_FILE}" )"
  readonly PM_MODULE_DIR="${MODULES_DIR}/${PM}/${OS}"
fi

# Helper functions available to other scripts. This only works with bash.
# TODO: Source these as normal functions within the subshells.
source "${SCRIPT_DIR}/functions.shlib"
[[ ! -f "${PM_MODULE_DIR}/functions.shlib" ]] || source "${PM_MODULE_DIR}/functions.shlib"

invoke_module_script() {
  local script="$1"
  local module_name="$2"
  local modules_dir="$3"
  local required="${4:---required=true}"
  local module_dir="${modules_dir}/${module_name}/${OS}"
  local module_script="${module_dir}/${script}"
  if [[ -f "${module_script}" ]]; then
    set +e
    (
      cd "${module_dir}"
      "${module_script}" "${@:3}"
    )
    [[ "$?" -eq 0 ]] || { 2>&1 echo "Failed!"; exit "${EXIT_MODULE_SCRIPT_FAILED}"; }
    set -e
  elif [[ "${required}" != "--required=false" ]]; then
    2>&1 echo "Module ${module_name} is missing script ${script} (${module_script})."
  fi
}

invoke_pm_script() {
  local script="$1"
  if [[ -z "${PM_MODULE_DIR+x}" ]]; then
    (
      cd "${PM_MODULE_DIR}"
      "${PM_MODULE_DIR}/${script}"
    )
  fi
}

invoke_all_modules_script() {
  local script="$1"
  local modules_file="$2"
  local modules_dir="$3"
  local message="$4"
  local required="$5"
  if [[ -f "${modules_file}" ]]; then
    local line
    while IFS='' read -r line || [[ -n "${line}" ]]; do
      line="${line#"${line%%[![:space:]]*}"}"
      line="${line%"${line##*[![:space:]]}"}"
      if [[ -n "${line}" && ! "${line}" =~ $COMMENT_REGEX ]]; then
        declare -a "module_command=( ${line} )"
        printf "${message}" "${module_command[*]}"
        invoke_module_script "${script}" "${module_command[@]}" "${modules_dir}" "${required}"
      fi
    done < "${modules_file}"
  fi
}

install_pm() {
  invoke_pm_script "install.sh"
}

install_all_modules() {
  invoke_all_modules_script "install.sh" "${MODULES_FILE}" "${MODULES_DIR}" "Installing %s...\n" "--required=true"
  invoke_all_modules_script "install.sh" "${CUSTOM_MODULES_FILE}" "${CUSTOM_MODULES_DIR}" "Installing custom %s...\n" "--required=false"
}

upgrade_pm() {
  invoke_pm_script "upgrade.sh"
}

upgrade_all_modules() {
  invoke_all_modules_script "upgrade.sh" "${MODULES_FILE}" "${MODULES_DIR}" "Upgrading %s...\n" "--required=true"
  invoke_all_modules_script "upgrade.sh" "${CUSTOM_MODULES_FILE}" "${CUSTOM_MODULES_DIR}" "Upgrading custom %s...\n" "--required=false"
}

configure_modules() {
  local modules_file="$1"
  local modules_dir="$2"
  local modules_config_dir="$3"
  if [[ -f "${modules_file}" ]]; then
    local line
    while IFS='' read -r line || [[ -n "${line}" ]]; do
      line="${line#"${line%%[![:space:]]*}"}"
      line="${line%"${line##*[![:space:]]}"}"
      if [[ -n "${line}" && ! "${line}" =~ $COMMENT_REGEX ]]; then
        declare -a "module_command=( ${line} )"
        local module_name="${module_command[0]}"
        local module_dir="${modules_dir}/${module_name}/${OS}"
        local module_config_dir="${module_config_dir}/${module_name}"
        if [[ -f "${module_dir}/configure.sh" ]]; then
          echo "Configuring ${module_name}..."
          invoke_module_script "configure.sh" "${module_name}" "${modules_dir}"
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

configure_all_modules() {
  configure_modules "${MODULES_FILE}" "${MODULES_DIR}" "${MODULES_CONFIG_DIR}"
  configure_modules "${CUSTOM_MODULES_FILE}" "${CUSTOM_MODULES_DIR}" "${CUSTOM_MODULES_CONFIG_DIR}"
}

case "$1" in
  ""|install)
    install_pm
    install_all_modules
    configure_all_modules
    ;;
  upgrade)
    upgrade_pm
    upgrade_all_modules
    # TODO: Should this configure the modules?
    ;;
  reconfigure)
    configure_all_modules
    ;;
  *)
    2>&1 echo "Unknown command: $1"
    exit "${EXIT_UNKNOWN_COMMAND}"
esac
