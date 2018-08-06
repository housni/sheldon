#!/usr/bin/env bash

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
Sheldon.Util.String.split() {
  local -a parts
  parts=( ${2//"$1"/ } )

  echo "${parts[@]}"
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
  local trim
  local glue
  local joined

  glue="$1"
  trim="${#glue}"

  if [[ "$glue" == *"%"* ]]; then
    # We need to escape '%' since we are using printf.
    glue=${glue//%/%%}
  fi

  shift 1

  joined="$( printf "${glue}%s" "$@" )"
  joined="${joined:$trim}"

  echo "$joined"
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
# import Sheldon.Util.String as String
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
  local template
  local -n __shld_data
  local datum
  local -A defaults

  defaults=( ['before']='{:' ['after']='}' )
  if [[ $# -gt 2 ]]; then
    import Sheldon.Util.Array as Array
    # shellcheck disable=SC2154
    # shellcheck disable=SC2086
    $Array.update defaults "${3}"
  fi

  template="$1"
  __shld_data="$2"
  for datum in "${!__shld_data[@]}"; do
    template=${template//"${defaults['before']}""${datum}""${defaults['after']}"/"${__shld_data[$datum]}"}
  done
  echo "$template"
}

# See: https://stackoverflow.com/a/2265268/379786
Sheldon.Util.String.lower() {
  if [[ ! -z "$2" ]]; then
    echo "${1,,[$2]}"
  else
    echo "${1,,}"
  fi
}

Sheldon.Util.String.upper() {
  if [[ ! -z "$2" ]]; then
    echo "${1^^[$2]}"
  else
    echo "${1^^}"
  fi
}

Sheldon.Util.String.capitalize() {
  echo "${1^}"
}

Sheldon.Util.String.swapcase() {
  echo "${1~~}"
}

Sheldon.Util.String.length() {
  echo "${#1}"
}

Sheldon.Util.String.title() {
  local -c input

  input=( $1 )
  echo "${input[@]^}"
}
