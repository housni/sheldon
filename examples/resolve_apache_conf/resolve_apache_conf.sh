#!/usr/bin/env bash

# See README.md in this dir for details.
#
# Replaces placeholders in a template with parsed JSON configs and writes it to an Apache conf file..
#
# SYNOPSIS
#     $0 [dev|prod]
#

# Bootstrap Sheldon.
# shellcheck source=/dev/null
. ../../lib/sheldon/bootstrap.sh

# Use strict mode.
Sheldon.Core.Sheldon.strict

# Import required Sheldon modules.
import Sheldon.Transform.JSON as JSON
import Sheldon.Util.String as String

# Absolute path to the dir this script is in.
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC2154
# shellcheck disable=SC2086
# shellcheck disable=SC2034
resolve_apache_conf() {
  # Will hold an associative array whose key's and values will
  # correspond with the JSON object. Essentially, configs for an Apache vost.
  local -A configs

  # Will hold the contents of the template which has values we want to replace.
  local template

  # In a real world scenario, you might be downloading the JSON config file
  # from an S3 bucket for either dev or prod configs.
  #
  # Assign contents of config to a var.
  json=$(cat "${BASE_DIR}/conf/apache-${1}-conf.json")

  # Parse the JSON, assigning the result to the variable `configs`.
  # shellcheck disable=SC2153
  $JSON.loads "$json" configs

  # Assign the contents of our vhost template to a var.
  template=$(cat "${BASE_DIR}"/example.com.conf.tpl)

  # Replace placeholders in template with parsed JSON configs and echo result.
  $String.insert "$template" configs
}

declare deploy_env
# Other possible value: prod
deploy_env="${1:-dev}"

# Call function that replaces template above configs from JSON in an S3 bucket.
# An optional argument sets the S3 bucket name.
# Default: 041440807701-dev-sheldon (set in the function above).
result=$(resolve_apache_conf "${deploy_env}")

# Write the resolved config to a file on disk.
printf "%s" "$result" > "${BASE_DIR}"/example.com.conf

exit 0