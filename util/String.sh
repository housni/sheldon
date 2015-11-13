################################################################################
# Sheldon: The not-so-bashful Bash framework. Bazinga!
#
# @namespace Sheldon::Util::String
# @copyright Copyright 2015, Housni Yakoob (http://housni.org)
# @license http://opensource.org/licenses/bsd-license.php The BSD License
################################################################################


################################################################################
# Join string arguments with a glue string.
#
# ### Usage
#
# ```
# use Sheldon::Util::String as String
#
# declare NAME
# $String::join =NAME ' & ' Amy Sheldon
# echo "${NAME} = ShAmy"
# ```
# The above will yield 'Amy & Sheldon = ShAmy'.
#
# You can provide as many string arguments as you want to be joined:
# ```
# $String::join =NAME '/' Raj Howard Sheldon Leonard
# ```
# The above will yield 'Raj/Howard/Sheldon/Leonard'.
#
# @param string $1
#     The return key prefixed with '='.
# @param string $2
#     The glue that joins the strings together.
# @param array $3
#     The string to join with $2. You can provide as many arguments as you want.
# @assign
#     Join strings in $3 with the glue string, $2.
################################################################################
Sheldon::Util::String::join() {
  local assign
  local trim
  local glue
  local joined

  glue="$2"
  assign="$1"
  trim="${#glue}"

  if [[ "$glue" == *"%"* ]]
  then
    # We need to escape '%' since we are using printf.
    glue=${glue//%/%%}
  fi

  shift 2

  joined="$( printf "${glue}%s" "$@" )"
  joined="${joined:$trim}"

  _assign "$assign" "$joined"
}


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
# declare DIR
# declare STRING
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
# declare DIR
# declare STRING
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
# @param string $2
#     A string containing variable placeholders.
# @param array $3
#     An associate array where each key stands for a placeholder variable name
#     to be replaced with a value.
# @assign
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