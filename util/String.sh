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
# You can also specify the before and after strings:
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
# STRING='/var/www/<?client?>/<?domain?>/backup/database/<?filename?>'
# $String::insert -b '<?' -a '?>' =DIR "${STRING}" DATA
# echo "${DIR}"
# ```
# `${DIR}` will still be: /var/www/Jones/example.org/backup/database/backup.sql
#
# @param string $before -b optional
#     The string in front of the name of the variable place-holder. This
#     defaults to `'{:'`.
# @param string $after -a optional
#     The string after the name of the variable place-holder. Defaults to `'}'`.
# @param string $1
#     The return key prefixed with '='.
# @param string $str $2
#     A string containing variable placeholders.
# @param array $data $3
#     An associate array where each key stands for a placeholder variable name
#     to be replaced with a value.
# @assign string
#     $2 replaced with all the placeholders in $3.
################################################################################
Sheldon::Util::String::insert() {
  local str
  local -n Sheldon_string_data
  local before
  local after
  local index

  before='{:'
  after='}'
  index=''

  # Overwrite with values that are passed in.
  while getopts :a:b: index; do
    case "${index}" in
      a)
        after="${OPTARG}"
        ;;

      b)
        before="${OPTARG}"
        ;;
    esac
  done
  shift $(( OPTIND - 1 ))
  index=''

  str="$2"
  Sheldon_string_data="$3"
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
