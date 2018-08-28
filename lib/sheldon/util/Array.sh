#!/usr/bin/env bash

# See Sheldon.Util.Array.append().
#
# :param 1: (array) Array to push $2 into.
# :param 2: (array) Elements to push into $1.
# :returns: (void) Array $1 set by reference.
Sheldon.Util.Array.push() {
  local -n __shld_array
  __shld_array="$1"

  if [[ $# -gt 2 ]]; then
    local __shld_args
    shift
    __shld_args=( "${@}" )
  else
    local -n __shld_args
    __shld_args="$2"
  fi

  # We need to modify the reference to the original array so we do it like this.
  __shld_array=( "${__shld_array[@]}" "${__shld_args[@]}" )
}

# Alias of Sheldon.Util.Array.push.
# See Python's append().
Sheldon.Util.Array.append() {
  Sheldon.Util.Array.push "$@"
}

# TODO
Sheldon.Util.Array.pop() {
  local -n __shld_array
  local last

  __shld_array="$1"
  last="${__shld_array[${#__shld_array[@]}-1]}"

  # We need to modify the reference to the original array so we do it like this.
  __shld_array=( "${__shld_array[@]:0:${#__shld_array[@]}-1}" )
  echo "${last}"
}

# Adds new items, $2 to the beginning of the array $1.
#
# :param 1: (array) Array to push $2 into.
# :param 2: (array) Elements to push into $1.
# :returns: (void) Array $1 set by reference.
Sheldon.Util.Array.unshift() {
  local -n __shld_array1
  __shld_array1="$1"

  if [[ $# -gt 2 ]]; then
    local __shld_array2
    shift
    __shld_array2=( "${@}" )
  else
    local -n __shld_array2
    __shld_array2="$2"
  fi

  # We need to modify the reference to the original array so we do it like this.
  __shld_array1=( "${__shld_array2[@]}" "${__shld_array1[@]}" )
}

# Removes the first item of an array
#
# :param 1: (array) The array to shift.
# :returns: (string) Returns the shifted element.
Sheldon.Util.Array.shift() {
  local -n __shld_array
  local first
  __shld_array="$1"

  first="${__shld_array[*]:0:1}"

  # We need to modify the reference to the original array so we do it like this.
  __shld_array=( "${__shld_array[@]:1}" )
  echo "${first}"
}

#####
# Gets the first element in an array. Doesn't work on associative arrays.
#
# :param 1: (array) The array to use.
# :returns: (string) The first element in $1.
#####
Sheldon.Util.Array.first() {
  local -n __shld_array

  __shld_array="$1"
  echo "${__shld_array:0}"
}

#####
# Gets the last element in an array. Doesn't work on associative arrays.
#
# :param 1: (array) The array to use.
# :returns: (string) The last element in $1.
#####
Sheldon.Util.Array.last() {
  local -n __shld_array

  __shld_array="$1"
  echo "${__shld_array[${#__shld_array[@]}-1]}"
}

#####
# Join array elements with a glue string.
#
# :param 1: (string) The glue that joins the elements together.
# :param 2: (string) The array to use.
# :returns: (string) Array elements in $2 joined by glue string $2.
#####
Sheldon.Util.Array.implode() {
  local -n __shld_data
  local glue
  local joined
  local trim

  # If this contains '%s', it will break printf.
  glue="$1"
  __shld_data="$2"
  trim="${#glue}"

  if [[ "$glue" = *"%"* ]]; then
    # We need to escape '%' since we are using printf.
    glue=${glue//%/%%}
  fi

  joined="$( printf "${glue}%s" "${__shld_data[@]}" )"
  joined="${joined:$trim}"

  echo "${joined}"
}

# Update array, $1, with the key/value pairs from other, overwriting
# existing keys.
#
# :param 1: (array) Array to be updated by $1.
# :param 2: (array) Array to update $1 with.
# :returns: (void) Array $1 set by reference.
Sheldon.Util.Array.update() {
  local -n __shld_defaults
  local -n __shld_others
  local default
  local others

  __shld_defaults="$1"
  __shld_others="$2"

  # If corresponding value in '__shld_others' will overwrite the valye in '__shld_defaults'.
  # Unset the key for that value in '__shld_others'.
  for default in "${!__shld_defaults[@]}"; do
    if [[ "${__shld_others[$default]+housni}" ]]; then
      __shld_defaults["$default"]="${__shld_others["$default"]}"
      unset __shld_others["$default"]
    fi

  done

  # Add remaining '__shld_others' to '__shld_defaults'.
  for others in "${!__shld_others[@]}"; do
    __shld_defaults["$others"]="${__shld_others["$others"]}"
  done
}