################################################################################
# Sheldon: The not-so-bashful Bash framework. Bazinga!
#
# @namespace Sheldon.Util.Array
# @copyright Copyright 2015, Housni Yakoob (http://housni.org)
# @license http://opensource.org/licenses/bsd-license.php The BSD License
################################################################################




Sheldon.Util.Array.push() {
  local -n _shld_array

  _shld_array="$1"
  if [ $# -gt 2 ]; then
    local _shld_args
    shift
    _shld_args=( "${@}" )
  else
    local -n _shld_args
    _shld_args="$2"
  fi

  # We need to modify the reference to the original array so we do it like this.
  _shld_array=( "${_shld_array[@]}" "${_shld_args[@]}" )

  _assign[] "$1" "${_shld_array[@]}"
}


# declare HTML
# declare -a dirs
# dirs=( var www html )
# $Array.pop =HTML dirs
# echo "$HTML" # html
# echo "${dirs[@]}" # var www
Sheldon.Util.Array.pop() {
  local -n _shld_array
  local _shld_last

  _shld_array="$2"
  _shld_last="${_shld_array[${#_shld_array[@]}-1]}"

  # We need to modify the reference to the original array so we do it like this.
  _shld_array=( "${_shld_array[@]:0:${#_shld_array[@]}-1}" )

  _assign "$1" "${_shld_last}"
  _assign[] "$2" "${_shld_array[@]}"
}



Sheldon.Util.Array.unshift() {
  local -n _shld_array1

  _shld_array1="$1"
  if [ $# -gt 2 ]; then
    local _shld_array2
    shift
    _shld_array2=( "${@}" )
  else
    local -n _shld_array2
    _shld_array2="$2"
  fi

  # We need to modify the reference to the original array so we do it like this.
  _shld_array1=( "${_shld_array2[@]}" "${_shld_array1[@]}" )

  _assign[] "$1" "${_shld_array1[@]}"
}


# declare RES
# declare -a parts
#
# parts=( var www html )
# $Array.shift =RES parts
# echo "${RES}" # should show 'var' which also should no longer exist in $parts.
Sheldon.Util.Array.shift() {
  local -n _shld_array
  local _shld_first

  _shld_array="$2"
  _shld_first="${_shld_array[@]:0:1}"

  # We need to modify the reference to the original array so we do it like this.
  _shld_array=( "${_shld_array[@]:1}" )

  _assign "$1" "${_shld_first}"
  _assign[] "$2" "${_shld_array[@]}"
}


################################################################################
# Gets the first element in an array. Doesn't work on associative arrays.
#
# ### Usage
#
# ```
# use Sheldon.Util.Array as Array
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
  local -n _shld_array

  _shld_array="$2"
  _assign "$1" "${_shld_array:0}"
}


################################################################################
# Gets the last element in an array. Doesn't work on associative arrays.
#
# ### Usage
#
# ```
# use Sheldon.Util.Array as Array
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
  local -n _shld_array

  _shld_array="$2"
  _assign "$1" "${_shld_array[${#_shld_array[@]}-1]}"
}


################################################################################
# Join array elements with a glue string.
#
# ### Usage
#
# ```
# use Sheldon.Util.Array as Array
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
  local -n _shld_data
  local _shld_glue
  local _shld_joined
  local _shld_trim

  # If this contains '%s', it will break printf.
  _shld_glue="$2"
  _shld_data="$3"
  _shld_trim="${#_shld_glue}"

  if [[ "$_shld_glue" == *"%"* ]]
  then
    # We need to escape '%' since we are using printf.
    _shld_glue=${_shld_glue//%/%%}
  fi

  _shld_joined="$( printf "${_shld_glue}%s" "${_shld_data[@]}" )"
  _shld_joined="${_shld_joined:$_shld_trim}"

  _assign "$1" "${_shld_joined}"
}