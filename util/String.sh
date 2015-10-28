################################################################################
# Sheldon: The not-so-bashful Bash framework. Bazinga!
#
# @namespace Sheldon::Util::String
# @copyright Copyright 2015, Housni Yakoob (http://housni.org)
# @license http://opensource.org/licenses/bsd-license.php The BSD License
################################################################################

################################################################################
# Replaces variable placeholders inside a string with any given data. Each key
# in the `$data` array corresponds to a variable placeholder name in `$str`.
#
# The placeholder keys must be of the form `{:my_placeholder_value}`.
#
# ### Usage
#
# ```
# use Sheldon::Util::String as String
#
# declare -x DIR
# declare -x STRING
# declare -A DATA
#
# DATA=(
#  ['client']='Jones'
#  ['domain']='example.org'
#  ['filename']='backup.sql'
# );
# STRING='/var/www/{:client}/{:domain}/backup/database/{:filename}'
# $String::insert =DIR "${STRING}" DATA
# echo "${DIR}"
# ```
# `${DIR}` will now be: /var/www/Jones/example.org/backup/database/backup.sql
#
# @param string $1
#     The return key prefixed with '='.
# @param string $str $2
#     A string containing variable placeholders.
# @param array $data $3
#     An associate array where each key stands for a placeholder variable name
#     to be replaced with a value.
# @param string $before $4 optional
#     The string in front of the name of the variable place-holder. This
#     defaults to `'{:'`.
# @param string $before $5 optional
#     The string after the name of the variable place-holder. Defaults to `'}'`.
# @assign string
#     $2 replaced with all the placeholders in $3.
################################################################################
Sheldon::Util::String::insert() {
  local str
  local -n Sheldon_string_data
  local before
  local after
  local index

  str="$2"
  Sheldon_string_data="$3"
  before="${4:-"{:"}"
  after="${5:-"}"}"
  index=''

  for index in "${!Sheldon_string_data[@]}"; do
    str=${str//"${before}""${index}""${after}"/"${Sheldon_string_data[$index]}"}
  done

  _assign "$1" "$str"
}

# TODO
Sheldon::Util::String::join() {
  local tmp

  tmp="${IFS}"
  IFS="${1:-"$tmp"}"

  shift
  echo "$*"
  IFS="${tmp}"
}