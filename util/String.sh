################################################################################
# Sheldon: The not-so-bashful Bash framework. Bazinga!
#
# @author Housni Yakoob
# @namespace Sheldon.Util.String
# @copyright Copyright 2015, Housni Yakoob (http://housni.org)
# @license http://opensource.org/licenses/bsd-license.php The BSD License
################################################################################


################################################################################
## @brief Splits a string into an array by a delimiter.
##
## Behaving a lot like PHP's \c explode() function, this creates an array of
## strings, each of which is a substring of string formed by splitting it on
## boundaries formed by the string delimiter in \b $2.
##
## # USAGE
## \b String.explode \b =\e ASSIGN \e DELIMITER \e STRING
##
##
## @param string $1 The \e ASSIGN key prefixed with '='.
## @param string $2 The \e DELIMITER that will split the \e STRING
## @param string $3 The \e STRING to be split by the \e DELIMITER
## @assigns An array of elements where each element is one of \e STRING that was
## separated by the \e DELIMITER.
## # EXAMPLES
## @dontinclude ./tests/StringTest.sh
## From tests/StringTest.sh:
## @skip use
## @until String
## @skip testExplode
## @until }
################################################################################
Sheldon.Util.String.explode() {
  local -a _shld_parts
  _shld_parts=(${3//"$2"/ })

  _assign[] "$1" _shld_parts
}


################################################################################
## @brief Join string arguments with a glue string.
##
## # USAGE
## \b String.join \b =\e ASSIGN \e GLUE \e STRING ...
##
##
## @param string $1 The \e ASSIGN key prefixed with '='.
## @param string $2 The \e GLUE that joins the strings together.
## @param array $3 The \e STRING to join with $2. You can provide as many
## arguments as you want.
## @assigns Strings in $3 with the glue string, $2.
## # EXAMPLES
## @dontinclude ./tests/StringTest.sh
## From tests/StringTest.sh:
## @skip use
## @until String
## @skip testJoin
## @until }
################################################################################
Sheldon.Util.String.join() {
  local _shld_assign
  local _shld_trim
  local _shld_glue
  local _shld_joined

  _shld_glue="$2"
  _shld_assign="$1"
  _shld_trim="${#_shld_glue}"

  if [[ "$_shld_glue" == *"%"* ]]
  then
    # We need to escape '%' since we are using printf.
    _shld_glue=${_shld_glue//%/%%}
  fi

  shift 2

  _shld_joined="$( printf "${_shld_glue}%s" "$@" )"
  _shld_joined="${_shld_joined:$_shld_trim}"

  _assign "$_shld_assign" "$_shld_joined"
}


################################################################################
# /*!
# @namespace Sheldon.String
# @abstract Replaces variable placeholders inside a string with any given data.
# @discussion Each key in the associate array, $3, corresponds to a variable
# placeholder name in $2.
# By default, the placeholder keys must be of the form `{:my_placeholder}`.
# <pre>
# @textblock
# use Sheldon.Util.String as String
#
# declare result
# declare template
# declare -A data
#
# data=(
#   ['who']='Housni'
#   ['domain']='housni.org'
#   ['filename']='backup.sql'
# );
# template='/var/www/{:who}/{:domain}/backup/database/{:filename}'
# $String.insert =result "${template}" data
# # '$result' will contain '/var/www/Housni/housni.org/backup/database/backup.sql'
#
# #
# # You can also specify the before and after strings:
# #
# template='/var/www/<?who?>/<?domain?>/backup/database/<?filename?>'
# $String.insert =result "$template" data -b '<?' -a '?>'
# # '$result' will contain '/var/www/Housni/housni.org/backup/database/backup.sql'
#
# #
# # You can also specify either the 'after' or 'before' string:
# #
# template='/var/www/{:who]/{:domain]/backup/database/{:filename]'
# $String.insert =result "$template" data -a ']'
# # '$result' will contain '/var/www/Housni/housni.org/backup/database/backup.sql'
# @/textblock
# </pre>
# @param $1
#     (string) The assign key prefixed with '='.
# @param $2
#     (string) A string containing variable placeholders.
# @param $3
#     (array) An associate array where each key stands for a placeholder
#     variable name to be replaced with a value.
# @param -b
#     (string) The optional string in front of the name of the variable
#     place-holder. This defaults to '{:'.
# @param -a
#     (string) The optional string after the name of the variable place-holder.
#     Defaults to '}'.
# @attribute assign
#     $2 replaced with all the placeholders in $3.
# */
################################################################################
Sheldon.Util.String.insert() {
  local _shld_str
  local -n _shld_data
  local _shld_before
  local _shld_after
  local _shld_index
  local OPTIND

  _shld_before='{:'
  _shld_after='}'
  _shld_index=''

  # Allow options to be passed in after non-option params.
  OPTIND=4

  # Overwrite with values that are passed in.
  while getopts "a:b:" _shld_index; do
    case "$_shld_index" in
      a)
        _shld_after="${OPTARG}"
        ;;

      b)
        _shld_before="${OPTARG}"
        ;;
    esac
  done
  _shld_index=''

  _shld_str="$2"
  _shld_data="$3"
  for _shld_index in "${!_shld_data[@]}"; do
    _shld_str=${_shld_str//"${_shld_before}""${_shld_index}""${_shld_after}"/"${_shld_data[$_shld_index]}"}
  done

  _assign "$1" "$_shld_str"
}
