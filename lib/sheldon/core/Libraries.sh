#!/usr/bin/env bash

# For Library.sh, we have to manually source files since the function that
# sources is defined below and it can't be used until it's defined.
# shellcheck source=/dev/null
# shellcheck disable=SC2154
. "${__SHELDON[lib]}"/util/Array.sh

#####
# Locates and sources the script.
#####
# This function assumes the first parameter is a namespace separated by '.' 
# (default). Based on this format, it acts like a rudimentary autoloader and
# sources the file. The second optional parameter can be used to specify a
# different separator.
##### Usage
# ```
# Sheldon.Core.Libraries.load  Sheldon.Util.String
# ```
# The above will source the file `util/String.sh`.
#
# Hypothetically, if all the functions were renamed so that instead of '.'
# being the separator, '::' was used instead, we could do this:
# ```
# Sheldon.Core.Libraries.load  "Sheldon.Util.String" "::"
# ```
#
# https://thomas-cokelaer.info/tutorials/sphinx/rest_syntax.html#explicit-links
# @see import()
#
# :param 1: (string) The namespace of the file you want to source.
# :param 2: (string) The separator used in $1.
# :returns: (void) Sources file corresponding to $1.
Sheldon.Core.Libraries.load() {
  local namespace
  local separator
  local path
  local -a parts
  local -i len
  local script

  namespace="${1}"
  separator="${2:-.}"

  # TODO: Check for '*' and escape it.
  IFS=$"${separator}" read -ra parts <<< "$namespace"

  # Validate that we are using this for Sheldon libs.
  if [[ ! "${parts[0]}" = 'Sheldon' ]]; then
    _error 'Invalid library'
  fi

  # We don't need the part with 'Sheldon'.
  unset "parts[0]"

  # Move the file base name to `_shld_script`.
  len="${#parts[@]}"
  script="${parts[len]}"
  unset "parts[len]"

  # Join the parts and convert them to lower case.
  path=$(printf "/%s" "${parts[@]}")
  path="${path,,}"

  # Append the file base name and the extension.
  path="${path}/${script}.sh"

  # Make sure the file is sourced only once in a shell.
  IFS=$" " read -ra libs_loaded <<< "${__SHELDON[libs_loaded]}"
  for each_lib in "${libs_loaded[@]}"; do
    if [[ "$each_lib" == "$namespace" ]]; then
      # If a lib has already been loaded, we don't need to source it again
      return
    fi
  done

  . "${__SHELDON[lib]}${path}" && \
    __SHELDON[libs_loaded]="${__SHELDON[libs_loaded]} $namespace"
}
