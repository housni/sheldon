#!/usr/bin/env bash

# Run all
#  ./test.sh

# Run only ArrayTest.sh
#  ./test.sh ArrayTest

# Run ArrayTest.testFirst
#  ./test.sh ArrayTest.testFirst


BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

. "$BASE_DIR/../meemaw.sh"
set +o errtrace

# set -x

use Sheldon.Test.TestFrameworkInAFile as Test

# Path to test file.
declare testFile

declare allTestFiles

# Basename of test file, $testFile.
declare testFilename
declare parsedFilename

declare testOutput

declare testNamespace
declare testFunc
declare parsedFunc

# shopt -s nullglob

$Test.header "Testing"

allTestFiles="$(realpath $BASE_DIR/../tests/*.sh)"
for testFile in $allTestFiles
do

  testFilename="$(basename ${testFile} .sh)"

  # If a test file is specified, then run only that and skip the others.
  if [ $# -gt 0 ]; then
    parsedFilename="$1"
    if [ "$1" != "${1/./}" ]; then
        parsedArgs=(${1//"."/ })
        parsedFilename=${parsedArgs[0]}
        parsedFunc="${parsedArgs[${#parsedArgs[@]}-1]}"
    fi

    if [ "$testFilename" != "$parsedFilename" ]; then
      continue
    fi
  fi

  $Test.bold "\nFile: ${testFile}"

  . "${testFile}"

  if [ "$(type -t $testFilename.setUp)" = 'function' ]; then
    $testFilename.setUp
  fi

  for testOutput in `declare -F`
  do
    testNamespace=${testOutput%.*}
    testFunc=${testOutput#*.}

    # If we have assigned parsedFunc earlier, that means a specific function
    # name was passed in as a param, so we only allow that function to run.
    if [ ! -z "$parsedFunc" ] && [ "$testFunc" != "$parsedFunc" ]; then
      continue
    fi

    # Match namespace with file name.
    # Make sure it's not a setUp() or tearDown() method.
    # Make sure the function begins with 'test'.
    if [ "$testNamespace" = "$testFilename" \
        -a "$testFunc" != 'setUp' \
        -a "$testFunc" != 'tearDown' \
        -a 'test' = "${testFunc:0:4}" ]; then
      $testFilename.$testFunc
    fi
  done
  if [ "$(type -t $testFilename.tearDown)" = 'function' ]; then
    $testFilename.tearDown
  fi
echo
done

$Test.summary
#trap $Test.summary EXIT
