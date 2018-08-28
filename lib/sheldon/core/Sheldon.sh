#!/usr/bin/env bash

#####
# Causes Sheldon to run in strict mode. It is recommended you always use this.
#
# If you expect a command to fail but you don't want execution to stop, return
# a true by appending ` || true` to it like:
# ```
# # This will abort.
# count=$(grep -c some_string some_file)
#
# # This will continue.
# count=$(grep -c some_string some_file || true)
# ```
#
# The other option is to temporarily suspend the exiting when any command
# exits with a non-zero status
# ```
# set +e
# # your command here
# set -e
# ```
#
# :returns: (void)
#####
Sheldon.Core.Sheldon.strict() {
  # Exit if any command exits with a non-zero exit status.
  set -e

  # Exit if script uses undefined variables.
  set -u

  # Prevent masking an error in a pipeline.
  #
  # Look at the end of the 'Use set -e' section for an excellent explanation.
  # See: https://www.davidpashley.com/articles/writing-robust-shell-scripts/
  set -o pipefail
}