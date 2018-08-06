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
  $Test.it "Should pass if the value of '$arg' is '$expected'." <<EOF
     [[ ${Sheldon["register.${arg}"]} = "$expected" ]]
EOF
}
