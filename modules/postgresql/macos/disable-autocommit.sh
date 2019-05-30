#!/usr/bin/env bash

set -e

text_to_add=$'-- Disable autocommit. It will only lead to an accident.\n'\
'\set AUTOCOMMIT off'
add_to_file ~/".psqlrc" '\set AUTOCOMMIT off' "${text_to_add}"
