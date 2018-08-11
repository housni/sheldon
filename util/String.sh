#!/usr/bin/env bash


################################################################################
## @brief Splits a string into an array by a delimiter.
##
## Behaving a lot like PHP's \c explode() function, this creates an array of
## strings, each of which is a substring of string formed by splitting it on
## boundaries formed by the string delimiter in \b $2.
##
## @param string $1 The \e DELIMITER that will split the \e STRING
## @param string $2 The \e STRING to be split by the \e DELIMITER
## @returns An array of elements where each element is one of \e STRING that was
## separated by the \e DELIMITER.
################################################################################
Sheldon.Util.String.split() {
  local -a parts
  IFS=$"${1}" read -ra parts <<< "$2"

  echo "${parts[@]}"
}


################################################################################
## @brief Join string arguments with a glue string.
##
## @param string $1 The \e GLUE that joins the strings together.
## @param array $2 The \e STRING to join with $1. You can provide as many
## arguments as you want.
## @returns Strings in $2 with the glue string, $1.
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
# @abstract Replaces variable placeholders inside a string with any given data.
# @discussion Each key in the associate array, $3, corresponds to a variable
# placeholder name in $2.
# By default, the placeholder keys must be of the form `{{my_placeholder}}`.
#
# @param $1
#     (string) A string containing variable placeholders.
# @param $2
#     (array) An associate array where each key stands for a placeholder
#     variable name to be replaced with a value.
# @param $3
#     (array) An associate array with two optional keys, `before` and `after`
#     which are the prefix ('{{' by default) and suffix ('}}' by default) for
#     the placeholder, $2.
# @return (string)
#     The template replaced with placeholders.
################################################################################
Sheldon.Util.String.insert() {
  local template
  local -n __shld_data
  local datum
  local -A defaults

  defaults=( ['before']='{{' ['after']='}}' )
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
  if [[ -z "${2:-}" ]]; then
    echo "${1,,}"
  else
    echo "${1,,[$2]}"
  fi
}

Sheldon.Util.String.upper() {
  if [[ -z "${2:-}" ]]; then
    echo "${1^^}"
  else
    echo "${1^^[$2]}"
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
  local input
  IFS=$" " read -ra input <<< "$1"
  echo "${input[@]^}"
}
