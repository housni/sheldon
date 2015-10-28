################################################################################
# Sheldon: The not-so-bashful Bash framework. Bazinga!
#
# @namespace Sheldon::Core::Libraries
# @copyright Copyright 2015, Housni Yakoob (http://housni.org)
# @license http://opensource.org/licenses/bsd-license.php The BSD License
################################################################################

################################################################################
# Locates and sources the script based on $1. This function assumes the first
# parameter is a namespace, of sorts, separated by '::' (default). Based on this
# format, it acts like a rudimentary autoloader and sources the file.
# The second optional parameter can be used to specify a different separater.
#
# ### Usage
#
# ```
# Sheldon::Core::Libraries::load  Sheldon::Util::String
# ```
# The above will source the file `util/String.sh`.
#
# Hypothetically, if all the functions were renamed so that instead of '::'
# being the separator, '.' was used instead, we could do this:
# ```
# Sheldon.Core.Libraries.load  "Sheldon.Util.String" ".".
# ```
#
# @see use()
# @param string $namespace $1
#     The namespace (as it were) of the file you want to source.
# @param string $separator $2 optional
#     The separator used in $namespace.
################################################################################
Sheldon::Core::Libraries::load() {
  local namespace
  local separator
  local path
  local parts
  local -i len
  local script
  local tmp
  local dir

  namespace="${1}"
  separator="${2:-'::'}"

  tmp=${IFS}
  IFS="${separator}" read -a parts <<< "${namespace}"
  IFS=${tmp}

  # Validate that we are using this for Sheldon libs.
  if [[ ! "${parts[0]}" = 'Sheldon' ]]; then
    _error 'Invalid library'
  fi

  # We don't need the part with 'Sheldon'.
  unset parts[0]

  # TODO: Should use Array::pop.
  # Move the file base name to `script`.
  len="${#parts[@]}"
  script="${parts[len]}"
  unset parts[len]

  # Join the parts in the middle together.
  for dir in "${!parts[@]}"; do
    path+="${parts[dir],,}/"
  done

  # Append the file base name and the extension.
  path="${path}${script}.sh"

  . "${Sheldon[dir]}/${path}"
}