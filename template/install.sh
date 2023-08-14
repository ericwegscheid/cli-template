#!/usr/bin/env zsh

_dst_init_file=$1
if [ ! -f "${_dst_init_file:-}" ]; then
  echo "Must provide a run command file or a shell initialization script, i.e. ./install.sh ~/.zshrc"
  return 0
fi

if grep -Fxq "source $(pwd)/index" "$_dst_init_file"; then
  echo "This CLI is already installed."
else
  sed -i "3i\_UTILNAME_cli_dir=$(pwd)" ./index
  echo "source $(pwd)/index" >> $_dst_init_file
  echo "CLI, $(pwd)/index, successfully installed!"
fi

