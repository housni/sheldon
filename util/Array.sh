

# 1 = Array to push $2 info
# 2... = Elements to push into $1
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


# declare HTML
# declare -a dirs
# dirs=( var www html )
# $Array.pop =HTML dirs
# echo "$HTML" # html
# echo "${dirs[@]}" # var www
# Sheldon.Util.Array.pop() {
#   local -n __shld_array
#   local last

#   __shld_array="$1"
#   last="${__shld_array[${#__shld_array[@]}-1]}"

#   # We need to modify the reference to the original array so we do it like this.
#   __shld_array=( "${__shld_array[@]:0:${#__shld_array[@]}-1}" )
#   echo "${last}"
# }

Sheldon.Util.Array.unshift() {
  local -n __shld_array1

  __shld_array1="$1"
  if [[ $# -gt 2 ]]; then
    local array2
    shift
    array2=( "${@}" )
  else
    local -n array2
    array2="$2"
  fi

  # We need to modify the reference to the original array so we do it like this.
  __shld_array1=( "${array2[@]}" "${__shld_array1[@]}" )
}

# declare RES
# declare -a parts
#
# parts=( var www html )
# $Array.shift =RES parts
# echo "${RES}" # should show 'var' which also should no longer exist in $parts.
Sheldon.Util.Array.shift() {
  local -n __shld_array
  local first

  __shld_array="$1"
  first="${__shld_array[@]:0:1}"

  # We need to modify the reference to the original array so we do it like this.
  __shld_array=( "${__shld_array[@]:1}" )
  echo "${first}"
}


################################################################################
# Gets the first element in an array. Doesn't work on associative arrays.
#
# ### Usage
#
# ```
# import Sheldon.Util.Array as Array
#
# declare FIRST
# declare -a parts
#
# parts=( var www html )
# $Array.first =FIRST parts
# echo "The first element is: ${FIRST}"
# ```
# `${FIRST}` will now be `var`.
#
# Using this is usually overkill. You're better off doing `foo=${myArray:0}`.
#
# @param string $1
#     The return key prefixed with '='.
# @param array $2
#     The array to use.
# @assign
#     The first element of $2 is assigned.
################################################################################
Sheldon.Util.Array.first() {
  local -n __shld_array

  __shld_array="$1"
  echo "${__shld_array:0}"
}


################################################################################
# Gets the last element in an array. Doesn't work on associative arrays.
#
# ### Usage
#
# ```
# import Sheldon.Util.Array as Array
#
# declare LAST
# declare -a parts
#
# parts=(first middle final)
# $Array.last =LAST parts
# echo "The last element is: ${LAST}"
# ```
# `${LAST}` will now be `final`.
#
# @param string $1
#     The return key prefixed with '='.
# @param array $2
#     The array to use.
# @assign
#     The last element of $2 is assigned.
################################################################################
Sheldon.Util.Array.last() {
  local -n __shld_array

  __shld_array="$1"
  echo "${__shld_array[${#__shld_array[@]}-1]}"
}

################################################################################
# Join array elements with a glue string.
#
# ### Usage
#
# ```
# import Sheldon.Util.Array as Array
#
# declare DESKTOP
# declare -a parts
#
# parts=("/home" housni Desktop)
# $Array.implode =DESKTOP '/' parts
# echo "My Desktop is located at: ${DESKTOP}"
# ```
# `${DESKTOP}` will now be `/home/housni/Desktop/`.
#
# @param string $1
#     The return key prefixed with '='.
# @param string $2
#     The string that joins the elements together.
# @param array $3
#     The array to use.
# @assign
#     Join array elements in $3 with the glue string, $2.
################################################################################
Sheldon.Util.Array.implode() {
  local -n __shld_data
  local glue
  local joined
  local trim

  # If this contains '%s', it will break printf.
  glue="$1"
  __shld_data="$2"
  trim="${#glue}"

  if [[ "$glue" == *"%"* ]]; then
    # We need to escape '%' since we are using printf.
    glue=${glue//%/%%}
  fi

  joined="$( printf "${glue}%s" "${__shld_data[@]}" )"
  joined="${joined:$trim}"

  echo "${joined}"
}

Sheldon.Util.Array.update() {
  local -n __shld_defaults
  local -n __shld_others
  local default

  __shld_defaults="$1"
  __shld_others="$2"

  for default in "${!__shld_defaults[@]}"; do
    if [[ "${__shld_others[$default]+housni}" ]]; then
      __shld_defaults["$default"]="${__shld_others[$default]}"
    fi
  done
}