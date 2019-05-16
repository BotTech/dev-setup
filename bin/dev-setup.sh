#!/usr/bin/env bash

set -e

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

config_dir="config/${os}"
pm="$(<"${config_dir}/pm")"
pm_module="modules/${pm}/${os}"
bash "${pm_module}/install.sh"

