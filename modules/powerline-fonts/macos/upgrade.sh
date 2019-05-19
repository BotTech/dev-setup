#!/usr/bin/env bash

temp_dir="$( mktemp -d )"
git -C "${temp_dir}" clone https://github.com/powerline/fonts.git
( "${temp_dir}/fonts/install.sh" )
rm -rf "$temp_dir"
