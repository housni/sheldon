RegistryTest.setUp() {
  import Sheldon.Storage.Registry as Registry
}

RegistryTest.tearDown() {
  :
}

RegistryTest.testSet() {
  local result
  local expected

  rand="$(mktemp -u)"

  arg1="${rand}foo"
  expected="bar"
  $Registry.set "$arg1" "$expected"
  $Test.it "Should pass if the value of '$arg1' is '$expected'." <<EOF
     [[ ${Sheldon["register.${arg1}"]} = "$expected" ]]
EOF
}
