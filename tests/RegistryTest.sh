#!/usr/bin/env bash

RegistryTest.setUp() {
  import Sheldon.Storage.Registry as Registry
}

RegistryTest.tearDown() {
  :
}

# shellcheck disable=SC2086
# shellcheck disable=SC2154
RegistryTest.testSet() {
  local rand
  local arg
  local expected

  rand="$(mktemp -u)"
  arg="${rand}foo"
  expected="bar"
  $Registry.set "$arg" "$expected"
  $Test.it "Should pass if the value of the key '$arg' has been set to '$expected' ." <<EOF
     [[ ${Sheldon[registry.${arg}]} = "$expected" ]]
EOF
}

RegistryTest.testGet() {
  local rand
  local arg
  local expected
  local result

  rand="$(mktemp -u)"
  arg="${rand}foo"
  Sheldon["registry.${arg}"]="bar"
  expected="bar"
  result=$($Registry.get "$arg")
  $Test.it "Should pass if the value of the key '$arg' that was retuend is '$expected' ." <<EOF
     [[ "$result" = "$expected" ]]
EOF
}
