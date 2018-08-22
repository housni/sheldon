#!/usr/bin/env bash

# Bootstrap Sheldon.
# shellcheck source=/dev/null
. ../../lib/sheldon/bootstrap.sh

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
  __custom="${1}"
  $Array.update options __custom

  for opt in "${!options[@]}"; do
    echo "$opt => ${options[$opt]}"
  done
}

declare -A custom
# shellcheck disable=SC2034
custom=( ["key2"]="custom value" ["another"]="foo" ["bar"]="baz" )
# Overwrite some values in 'something()' with values passed in via 'custom'.
something custom