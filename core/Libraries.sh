#!/usr/bin/env bash

################################################################################
# Sheldon: The not-so-bashful Bash framework. Bazinga!
#
# @namespace Sheldon.Core.Libraries
# @copyright Copyright 2015, Housni Yakoob (http://housni.org)
# @license http://opensource.org/licenses/bsd-license.php The BSD License
################################################################################

# For Library.sh, we have to manually source files since the function that
# sources is defined below and it can't be used until it's defined.
# shellcheck source=/dev/null
# shellcheck disable=SC2154
. "${Sheldon[dir]}"/util/Array.sh

################################################################################
# Locates and sources the script based on $1. This function assumes the first
# parameter is a namespace, of sorts, separated by '.' (default). Based on this
# format, it acts like a rudimentary autoloader and sources the file.
# The second optional parameter can be used to specify a different separater.
#
# ### Usage
#
# ```
# Sheldon.Core.Libraries.load  Sheldon.Util.String
# ```
# The above will source the file `util/String.sh`.
#
# Hypothetically, if all the functions were renamed so that instead of '.'
# being the separator, '.' was used instead, we could do this:
# ```
# Sheldon.Core.Libraries.load  "Sheldon.Util.String" ".".
# ```
#
# @see import()
# @param string $1
#     The namespace (as it were) of the file you want to source.
# @param string $2 optional
#     The separator used in $_shld_namespace.
################################################################################
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
  path=$(Sheldon.Util.Array.implode '/' parts)
  path="${path,,}"

  # Append the file base name and the extension.
  path="${path}/${script}.sh"

  # TODO: Make sure the file is sourced only once in a shell.
  . "${Sheldon[dir]}/${path}"
}