#!/usr/bin/env bash

# Bootstrap Sheldon.
# shellcheck source=/dev/null
. "${0%/*}/../../lib/sheldon/bootstrap.sh"

# Use strict mode.
Sheldon.Core.Sheldon.strict

# Import required Sheldon modules.
import Sheldon.Util.Array as Array

# shellcheck disable=SC2154
# shellcheck disable=SC2086
# shellcheck disable=SC2034
something() {
  local -A options
  local -n __custom

  options=( ["key1"]="val1" ["key2"]="val2" ["key3"]="val3" )
  
  echo "Default options:"
  for opt in "${!options[@]}"; do
    echo "$opt => ${options[$opt]}"
  done
  echo

  __custom="${1}"
  echo "User options:"
  for cust in "${!__custom[@]}"; do
    echo "$cust => ${__custom[$cust]}"
  done
  echo

  $Array.update options __custom

  echo "Merged options:"
  for opt in "${!options[@]}"; do
    echo "$opt => ${options[$opt]}"
  done
  echo
}

declare -A custom
# shellcheck disable=SC2034
custom=( ["key2"]="custom value" ["another"]="foo" ["bar"]="baz" )
# Overwrite some values in 'something()' with values passed in via 'custom'.
something custom