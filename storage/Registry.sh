################################################################################
# Sheldon: The not-so-bashful Bash framework. Bazinga!
#
# This is a rudimentary implementation of the Registry pattern.
#
# ### Usage
#
# ```
# use Sheldon.Storage.Registry as Registry
# declare WHO
# declare LOVES
# $Registry.set 'who' 'Sheldon'
# $Registry.set 'loves' 'Meemaw'
#
# # The result is stored in the upper case version of the key.
# $Registry.get 'who'
# $Registry.get 'loves'
# echo "${WHO} loves his ${LOVES}"
# ```
#
# @namespace Sheldon.Storage.Registry
# @copyright Copyright 2015, Housni Yakoob (http://housni.org)
# @license http://opensource.org/licenses/bsd-license.php The BSD License
################################################################################

################################################################################
# Getter for a rudimentary implementation of the Registry pattern.
#
# ### Usage
#
# ```
# Sheldon.Storage.Registry.set 'foo' 'bar'
# ```
#
# @param mixed $1
#     The key to store the value, $2, in.
# @param mixed $2
#     The value to be assigned to the key, $1.
################################################################################
Sheldon.Storage.Registry.set() {
  Sheldon["register.${1}"]="$2"
}

################################################################################
# Getter for a rudimentary implementation of the Registry pattern.
#
# ### Usage
#
# ```
# Sheldon.Storage.Registry.get 'foo'
# ```
# The above will assign the result to the upper case version of the key
# parameter ($1). So, the result would be in ${FOO}.
#
# @param mixed $1
#     The key from which you want to retrieve the value. The result is assigned
#     to the upper case version of this key.
# @assign
#     The value of the key in $1 is assigned.
################################################################################
Sheldon.Storage.Registry.get() {
  # Making the variable uppercase on declaration.
  local -u key

  # Appending literal '=' because '_assign()' requires it.
  key="=$1"
  _assign "${key}" "${Sheldon["register.${1}"]}"
}