################################################################################
# Sheldon: The not-so-bashful Bash framework. Bazinga!
#
# @namespace Sheldon::Util::Array
# @copyright Copyright 2015, Housni Yakoob (http://housni.org)
# @license http://opensource.org/licenses/bsd-license.php The BSD License
################################################################################


################################################################################
# Gets the first element in an array. Doesn't work on associative arrays.
#
# ### Usage
#
# ```
# use Sheldon::Util::Array as Array
#
# declare FIRST
# declare -a parts
#
# parts=(var www html)
# $Array::reset =FIRST parts
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
Sheldon::Util::Array::reset() {
  local -n array

  array="$2"
  _assign "$1" "${array:0}"
}


################################################################################
# Gets the last element in an array. Doesn't work on associative arrays.
#
# ### Usage
#
# ```
# use Sheldon::Util::Array as Array
#
# declare LAST
# declare -a parts
#
# parts=(first middle final)
# $Array::end =LAST parts
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
Sheldon::Util::Array::end() {
  local -n array

  array="$2"
  _assign "$1" "${array[${#array[@]}-1]}"
}


################################################################################
# Join array elements with a glue string.
#
# ### Usage
#
# ```
# use Sheldon::Util::Array as Array
#
# declare DESKTOP
# declare -a parts
#
# parts=("/home" housni Desktop)
# $Array::implode =DESKTOP '/' parts
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
Sheldon::Util::Array::implode() {
  local -n array
  local glue
  local tmp
  local assign

  assign="$1"
  glue="$2"
  array="$3"
  tmp="${IFS}"
  IFS="${glue}"

  shift 2

  _assign "$assign" "${array[*]}"
  IFS="${tmp}"
}