#!/usr/bin/env bash

# For Library.sh, we have to manually source files since the function that
# sources is defined below and it can't be used until it's defined.
# TODO: This lib should be in __SHELDON[libs_loaded]
#
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
# :param 3: TODO
# :returns: (void) Sources file corresponding to $1.
Sheldon.Core.Libraries.load() {
  local namespace
  local separator
  local path
  local -a parts
  local -i len
  local script
  local transformation

  namespace="${1}"
  separator="${2:-.}"
  transformation="${3:-}"

  # Make sure the file is sourced only once in a shell.
  IFS=$" " read -ra libs_loaded <<< "${__SHELDON[libs_loaded]}"
  for each_lib in "${libs_loaded[@]}"; do
    if [[ "$each_lib" == "$namespace" ]]; then
      # If a lib has already been loaded, we don't need to source it again
      return
    fi
  done


  # TODO: Check for '*' and escape it.
  IFS=$"${separator}" read -ra parts <<< "$namespace"

  transformation=$(Sheldon.Core.Libraries.load.transform)
  if [[ $# -lt 3 ]]; then
    transformation=$(Sheldon.Core.Libraries.load.transform)
  fi

  path="$($transformation "${parts[@]}")"


  IFS=$" " read -ra lib_paths <<< "${__SHELDON[lib]}"
  for lib_path in "${lib_paths[@]}"; do
    if [[ -f "${lib_path}/${path}" ]]; then
      . "${lib_path}/${path}" && \
        __SHELDON[libs_loaded]="${__SHELDON[libs_loaded]} $namespace"
      return
    fi
  done

  _error "The library '$namespace' does not exist at '${lib_path}${path}'" $LINENO "${BASH_SOURCE[0]}" 127
}

Sheldon.Core.Libraries.load.transform() {
  if [[ $# -eq 0 ]]; then
    echo "${__SHELDON[libs_transform]}"
    return
  fi

  __SHELDON[libs_transform]="${1}"
}





# TODO: Document this setter/getter
Sheldon.Core.Libraries.path() {
  # If a path is not set, return all paths
  if [[ $# -eq 0 ]]; then
      echo "${__SHELDON[lib]}"
      return
  fi

  __SHELDON[lib]="${1}"
}
