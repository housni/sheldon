#!/usr/bin/env bash

################################################################################
# Sheldon: The not-so-bashful Bash framework. Bazinga!
#
# @namespace Sheldon.Core.Sheldon
# @copyright Copyright 2015, Housni Yakoob (http://housni.org)
# @license http://opensource.org/licenses/bsd-license.php The BSD License
################################################################################

################################################################################
# Causes Sheldon to run in strict mode. It is recommended you always use this.
# If you expect a command to fail, append ` || true` to it like:
# ```
# # This will abort.
# count=$(grep -c some_string some_file)
#
# # This will continue.
# count=$(grep -c some_string some_file || true)
# ```
#
# The other option is to temporarily disable non-zero exits.
# ```
# set +e
# # your command here
# set -e
# ```
################################################################################
Sheldon.Core.Sheldon.strict() {
  # Exit if any command has a non-zero exit status.
  set -e

  # Exit if script uses undefined variables.
  set -u

  # Prevent masking an error in a pipeline.
  set -o pipefail
}