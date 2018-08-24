#!/usr/bin/env bash

JSONTest.setUp() {
  import Sheldon.Transform.JSON as JSON
}

JSONTest.tearDown() {
  :
}

JSONTest.testDump() {
  local -A arg
  local result
  local expected
  local -i count

  arg=( [one]="first" [two]="second" [three]="third" )
  expected='{"one":"First","two":"Second","three":"Third"}'
  # shellcheck disable=SC2086
  # shellcheck disable=SC2153
  result=$($JSON.dumps arg)

  # Because the orders can return unordered in Bash, we can't compare the array
  # too easily. Instead, I go through the array elements and search for them in
  # the result string. If the number of matches is the same as the number of
  # items in the array, it's a success.
  count=0
  for each in "${!arg[@]}"; do
    if [[ "$result" = *"\"${each}\":\"${arg[$each]}\""* ]]; then
      ((count++))
    fi
  done

  # shellcheck disable=SC2086
  # shellcheck disable=SC2154
  $Test.it 'Should pass if an associative Bash array is converted to a JSON string.' <<EOF
    [[ $count -eq ${#arg[@]} ]]
EOF
}

JSONTest.testLoads() {
  local json
  local -A expected
  local -A result
  local diff

  json='{"one":"First","two":"Second","three":"Third"}'
  expected=( [one]="First" [two]="Second" [three]="Third" )
  # shellcheck disable=SC2086
  {
    $JSON.loads "$json" result
    diff=$($Test.array_diff expected result)
    $Test.it 'Should pass if compact JSON string was converted to an associative Bash array.' <<EOF
    [[ -z "$diff" ]]
EOF
  }

  json='{
    "one":"First",
    "two":"Second",
    "three":"Third"
  }'
  # shellcheck disable=SC2086
  $JSON.loads "$json" result
  expected=( [one]="First" [two]="Second" [three]="Third" )
  # shellcheck disable=SC2086
  diff=$($Test.array_diff expected result)

  # shellcheck disable=SC2086
  $Test.it 'Should pass if multiline JSON string was converted to an associative Bash array.' <<EOF
      [[ -z "$diff" ]]
EOF

  result=()
  expected=()
  json='{ "o ne"   : "Fi\"rst" , "two":"Sec    ond","th/ree":"Thi\"rd"  }'
  # shellcheck disable=SC2034
  expected=( [o ne]="Fi\\\"rst" [two]="Sec    ond" [th/ree]="Thi\\\"rd" )
  # shellcheck disable=SC2086
  {
    $JSON.loads "$json" result
    diff=$($Test.array_diff expected result)
    # shellcheck disable=SC2086
    $Test.it 'Should pass if a super messy JSON string was converted to an associative Bash array.' <<EOF
      [[ -z "$diff" ]]
EOF
  }
}