################################################################################
# Sheldon: The not-so-bashful Bash framework. Bazinga!
#
# @namespace Sheldon.Core.Libraries
# @copyright Copyright 2015, Housni Yakoob (http://housni.org)
# @license http://opensource.org/licenses/bsd-license.php The BSD License
################################################################################

# For Library.sh, we have to manually source files since the function that
# sources is defined below and it can't be used until it's defined.
. ${Sheldon[dir]}/util/Array.sh

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
  local _shld_namespace
  local _shld_separator
  local _shld_path
  local -a _shld_parts
  local -i _shld_len
  local _shld_script

  _shld_namespace="${1}"
  _shld_separator="${2:-.}"

  # TODO: Check for '*' and escape it.
  _shld_parts=(${_shld_namespace//"$_shld_separator"/ })

  # Validate that we are using this for Sheldon libs.
  if [[ ! "${_shld_parts[0]}" = 'Sheldon' ]]; then
    _error 'Invalid library'
  fi

  # We don't need the part with 'Sheldon'.
  unset _shld_parts[0]

  # Move the file base name to `_shld_script`.
  _shld_len="${#_shld_parts[@]}"
  _shld_script="${_shld_parts[_shld_len]}"
  unset _shld_parts[_shld_len]

  # Join the parts and convert them to lower case.
  _shld_path=$(Sheldon.Util.Array.implode '/' _shld_parts)
  _shld_path="${_shld_path,,}"

  # Append the file base name and the extension.
  _shld_path="${_shld_path}/${_shld_script}.sh"

  # TODO: Make sure the file is sourced only once in a shell.
  . "${Sheldon[dir]}/${_shld_path}"
}