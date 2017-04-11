# set -o errtrace

Sheldon.Test.TestFrameworkInAFile.header() {
  local length
  local before
  local after
  local bold

  length=" $1 "
  length=${#length}
  before="\033["
  bold="1m"
  after="\033[0m"

  printf "${before}${bold}-%.0s${after}" $(seq 1 $length)
  printf "\n${before}${bold} $1 ${after}\n"
  printf "${before}${bold}-%.0s${after}" $(seq 1 $length)
  echo
}

Sheldon.Test.TestFrameworkInAFile.bold() {
  local before
  local after
  local bold

  before="\033["
  bold="1m"
  after="\033[0m"

  printf "${before}${bold} $1 ${after}"
  echo
}

################################################################################
# Each line will be evaluated as a statement, therefore, each line should be a
# valid statement - this means an if condition, for example, should be written
# on one line.
################################################################################
Sheldon.Test.TestFrameworkInAFile.it() {
  local message
  local line
  local state
  local _status_

  # Escaping literal % for printf.
  message=${1//"%"/"%%"}
  _SKIP_=
  state=0

  if [ ! -v _TESTPASS_ ]; then
    _TESTPASS_=0
  fi
  if [ ! -v _TESTFAIL_ ]; then
    _TESTFAIL_=0
  fi

  while read line; do
    eval "$line"
    _status_="$?"
    if [ "$_SKIP_" != 'true' ]; then
      if [ "$_status_" -eq 1 ]; then
        state=1
      fi
    fi
  done < <(cat $2)

  if [ "$_SKIP_" != 'true' ]; then
    if [ "$state" -eq 1 ]; then
      printf "\033[0;31m\xE2\x9C\x98 [FAIL] $message\033[0m\n"
      _TESTFAIL_="$(( _TESTFAIL_ + 1 ))"
    else
      printf "\033[0;32m\xE2\x9C\x94 [PASS] $message\033[0m\n"
      _TESTPASS_="$(( _TESTPASS_ + 1 ))"
    fi
  fi
}


Sheldon.Test.TestFrameworkInAFile.array_diff() {
  local -n array1
  local -n array2
  local diff

  array1="$2"
  array2="$3"
  # Setting 'true' on failure so that the _error() trap doesn't halt the script if the test fails.
  diff=$(diff <(printf "%s\n" "${array1[@]}") <(printf "%s\n" "${array2[@]}") || true)
  diff=$( echo -n $diff )
  _assign "$1" "$diff"
}

Sheldon.Test.TestFrameworkInAFile.skip() {
  _SKIP_="true"
  echo "SKIPPING: $1"
}

Sheldon.Test.TestFrameworkInAFile.summary() {
  echo "Total: ${_TESTPASS_} passes, ${_TESTFAIL_} fails."
}