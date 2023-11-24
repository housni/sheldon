#!/usr/bin/env bash

# Run all
#  ./test.sh

# Run only ArrayTest.sh
#  ./test.sh ArrayTest

# Run ArrayTest.testFirst
#  ./test.sh ArrayTest.testFirst

# shellcheck source=/dev/null
. "${0%/*}/../bootstrap.sh"
set +o errtrace

import Sheldon.Test.TestFrameworkInAFile as Test

# Path to test file.
declare testFile
declare allTestFiles
declare allTestPath
# Basename of test file, $testFile.
declare testFilename
declare parsedFilename
declare testOutput
declare testNamespace
declare testFunc
declare parsedFunc
declare functions
declare -i status

# shellcheck disable=SC2154
# shellcheck disable=SC2086
$Test.header "Testing"

allTestPath=$(readlink -f "${0%/*}/../tests")
allTestFiles="${allTestPath}/*.sh"

for testFile in $allTestFiles; do
  testFilename=$(basename "${testFile}" .sh)
  # If a test file is specified, then run only that and skip the others.
  if [ $# -gt 0 ]; then
    parsedFilename="$1"
    if [ "$1" != "${1/./}" ]; then
      IFS=$"." read -ra parsedArgs <<< "$1"
      parsedFilename=${parsedArgs[0]}
      parsedFunc="${parsedArgs[${#parsedArgs[@]}-1]}"
    fi

    if [ "$testFilename" != "$parsedFilename" ]; then
      continue
    fi
  fi

  # shellcheck disable=SC2086
  $Test.bold "\\nFile: ${testFile}"

  # shellcheck disable=SC1090
  . "${testFile}"
  if [[ "$(type -t "${testFilename}".setUp)" = 'function' ]]; then
    "${testFilename}".setUp
  fi

  # Function names.
  # shellcheck disable=SC2207
  IFS=$' \n\t' functions=( $(declare -F) )

  for testOutput in "${functions[@]}"; do
    IFS=$' \n\t' testNamespace=${testOutput%.*}
    testFunc=${testOutput#*.}
    # TODO: If function doesn't exist, show error.
    # If we have assigned parsedFunc earlier, that means a specific function
    # name was passed in as a param, so we only allow that function to run.
    if [ -n "$parsedFunc" ] && [ "$testFunc" != "$parsedFunc" ]; then
      continue
    fi

    # Match namespace with file name.
    # Make sure it's not a setUp() or tearDown() method.
    # Make sure the function begins with 'test'.
    if [[ "$testNamespace" = "$testFilename" ]] \
         && [[ "$testFunc" != 'setUp' ]] \
         && [[ "$testFunc" != 'tearDown' ]] \
         && [[ 'test' = "${testFunc:0:4}" ]]; then
      "${testFilename}.${testFunc}"
    fi
  done
  if [[ $(type -t "${testFilename}".tearDown) = 'function' ]]; then
    "${testFilename}".tearDown
  fi
echo
done

# shellcheck disable=SC2086
$Test.summary
#trap $Test.summary EXIT

# shellcheck disable=SC2086
status=$($Test.status)
exit "$status"
