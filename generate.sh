#!/usr/bin/env zsh

_install_cli() {
  if grep -Fxq "source $_cli_location/index" "$_cli_init_script"; then
    echo "CLI at $_cli_location/index is already sourced from $_cli_init_script."
  else
    echo "source $_cli_location/index" >> $_cli_init_script
  fi
  mkdir $_cli_location
  cp template/* $_cli_location/
  sed -i "s/UTILNAME/$_cli_name/g" $_cli_location/index
  sed -i "s/UTILNAME/$_cli_name/g" $_cli_location/install.sh
  sed -i "s/UTILNAME/$_cli_name/g" $_cli_location/README.md
  sed -i "3i\_$(echo $_cli_name)_cli_dir=$_cli_location" $_cli_location/index
  echo "CLI at $_cli_location/index has been successfully installed!"
}

_install_cli_prompt_name() {
  if [ "$1" = 'function_already_exists' ]; then
    echo -e "\nThe provided name, $2, is already in use. Please choose another name."
  elif [ "$1" = 'directory_already_exists' ]; then
    echo -e "\nCannot install new CLI at $2. This directory is already in use. Please choose another name."
  else
    echo -e "\nWhat would you like to call your CLI?"
  fi
  read _cli_name
  _cli_location=$(pwd | sed 's/\/[^\/]*$//')/$_cli_name
  if [ "$(functions | grep "^$_cli_name () {$")" != '' ]; then
    _install_cli_prompt_name 'function_already_exists' $_cli_name
  elif [ -d $_cli_location ]; then
    _install_cli_prompt_name 'directory_already_exists' $_cli_name
  fi
}

_install_cli_prompt_init_script() {
  if [ "$1" = 'invalid_input' ]; then
    echo -e "\nThe provided script, $2, does not exist, please try another."
  else
    echo -e "\nPlease provide a run command file or a shell initialization script, i.e. ~/.zshrc"
    echo "A source command will be appended to this file to source the index file in the CLI directory."
  fi
  read _init_script
  _cli_init_script="${_cli_init_script/#\~/$HOME}"
  if [ ! -f $_cli_init_script ]; then
    _install_cli_prompt_init_script 'invalid_input' $_cli_init_script
  fi
}

_install_cli_summary() {
  echo ''
  echo "CLI name:         $_cli_name"
  echo "CLI location:     $_cli_location"
  echo "CLI init script:  $_cli_init_script"
  echo ''
  echo 'Is this correct? y/n'
  read _resp

  if [ "$_resp" = y ] || [ "$_resp" = '' ]; then
    _install_cli
  else
    _install_cli_prompt_name
    _install_cli_prompt_init_script
    _install_cli_summary
  fi
}

_install_cli_prompt_name
_install_cli_prompt_init_script
_install_cli_summary
