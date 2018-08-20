#!/usr/bin/env bash

#####
# This is a rudimentary implementation of the Registry pattern.
#
##### Usage
#
# ```
# import Sheldon.Storage.Registry as Registry
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
#####

#####
# Getter for a rudimentary implementation of the Registry pattern.
#
##### Usage
#
# ```
# Sheldon.Storage.Registry.set 'foo' 'bar'
# ```
#
# :param 1: (mixed) The key to store the value, $2, in.
# :param 2: (mixed) The value to be assigned to the key, $1.
# :returns: (void)
#####
Sheldon.Storage.Registry.set() {
  Sheldon["registry.${1}"]="$2"
}

#####
# Getter for a rudimentary implementation of the Registry pattern.
#
# ### Usage
#
# ```
# Sheldon.Storage.Registry.get 'foo'
# ```
# The above will assign the result to the key, $1.
#
# :param 1: (mixed) The key from which you want to retrieve the value.
# :returns: (void)
#####
Sheldon.Storage.Registry.get() {
  echo "${Sheldon[registry.${1}]}"
}