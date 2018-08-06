#!/usr/bin/env bash

################################################################################
# Each line will be evaluated as a statement, therefore, each line should be a
# valid statement - this means an if condition, for example, should be written
# on one line.
################################################################################
Sheldon.Test.TestFrameworkInAFile.it() {
  local message
  local line
  local _status_
  local -a parts
  local main
  local sub

  parts=( ${FUNCNAME[1]//./ } )
  main="${parts[0]:0:-4}"
  sub="${parts[1]:4}"
  # Escaping literal % for printf.
  message="${main}.${sub,}: ${1//%/%%}"

  if [ -z "$_TESTPASS_" ]; then
    _TESTPASS_=0
  fi
  if [ -z "$_TESTFAIL_" ]; then
    _TESTFAIL_=0
  fi
  if [ -z "$_SKIP_COUNT" ]; then
    _SKIP_COUNT=0
  fi

  # If the second arg starts with a `skip`, then this test must be skipped.
  if [[ "$2" = "skip" ]]; then
    Sheldon.Test.TestFrameworkInAFile.skip "$3 ($message)"
    shift 2
    _SKIP_COUNT=$(( _SKIP_COUNT + 1 ))
  fi

  while read -r line; do
    eval "$line"
    _status_="$?"
    if [ "$_SKIP_" != 'true' ]; then
      if [ $_status_ -eq 1 ]; then
        printf "\033[0;31m\xE2\x9C\x98 [FAIL] %s\033[0m\n" "$message"
        _TESTFAIL_="$(( _TESTFAIL_ + 1 ))"
        printf "         %s\n" "${line[@]}"
      else
        printf "\033[0;32m\xE2\x9C\x94 [PASS] %s\033[0m\n" "$message"
        _TESTPASS_="$(( _TESTPASS_ + 1 ))"
      fi
    fi
  done < <($2)
  _SKIP_=
}

Sheldon.Test.TestFrameworkInAFile.skip() {
  _SKIP_="true"
  printf "\033[0;34m\xe2\x9c\x9a [SKIP] %s\033[0m\n" "$1"
}

Sheldon.Test.TestFrameworkInAFile.summary() {
  printf "Total: %i passes, %i fails, %i skipped.\n" \
    "${_TESTPASS_}" \
    "${_TESTFAIL_}" \
    "${_SKIP_COUNT}"
}

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

  printf "${before}${bold}-%.0s${after}" $(seq 1 "$length")
  printf "\n%b%b %b %b\n" "${before}" "${bold}" "$1" "${after}"
  printf "${before}${bold}-%.0s${after}" $(seq 1 "$length")
  echo
}

Sheldon.Test.TestFrameworkInAFile.bold() {
  local before
  local after
  local bold

  before="\033["
  bold="1m"
  after="\033[0m"

  printf "%b%b %b %b" "${before}" "${bold}" "$1" "${after}"
  echo
}

Sheldon.Test.TestFrameworkInAFile.array_diff() {
  local -n array1
  local -n array2
  local diff

  array1="$1"
  array2="$2"
  # Setting 'true' on failure so that the _error() trap doesn't halt the script if the diff fails.
  diff=$(diff <(printf "%s\n" "${array1[@]}") <(printf "%s\n" "${array2[@]}") || true)
  diff=$(echo -n "$diff")

  echo "${diff[@]}"
}

# If two arrays are equal, return 0, else return 1
Sheldon.Test.TestFrameworkInAFile.array_equal?() {
  local -n array1
  local -n array2

  array1="$1"
  array2="$2"

  if [[ "${#array1[@]}" -ne "${#array2[@]}" ]]; then
    echo 1
    return
  fi

  counter=0
  for xx in ${!array2[*]}; do
    for yy in ${!array1[*]}; do
      if [[ "${array2[xx]}" == "${array1[yy]}" ]]; then
        ((counter++))
      fi
    done
  done

  if [ $counter -ne ${#array1[@]} ]; then
    echo 1
    return
  fi

  echo 0
}