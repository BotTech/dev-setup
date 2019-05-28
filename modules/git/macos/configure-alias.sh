#!/usr/bin/env bash

# autocrlf is evil. If your editor can't handle different line endings then stop using that editor.
git config --global core.autocrlf false

suffix="$1"
description="$2"
alias="alias.config${suffix}"
git config --get "${alias}" > /dev/null
if [[ "$?" -ne 0 ]]; then
  echo "Enter your ${description} details"
  read -p 'User Name: ' userName < /dev/tty
  read -p 'Email Address: ' userEmail < /dev/tty
  git config --global "${alias}" "!git config user.name \"${userName}\" && git config user.email \"${userEmail}\""
  echo "Created git alias '${alias}'."
fi
