#!/usr/bin/env bash

StringTest.setUp() {
  import Sheldon.Util.String as String
}

StringTest.tearDown() {
  :
}

# shellcheck disable=SC2086
# shellcheck disable=SC2154
StringTest.testSplit() {
  local result
  local expected
  local args

  expected=( var www html )
  read -ra result <<< "$($String.split '/' '/var/www/html')"
  args=$($Test.array_diff result expected)
  $Test.it 'Should pass if a string is split correctly.' <<EOF
    [ -z "$args" ]
EOF

  expected=( Sheldon Leonard Howard Raj )
  read -ra result <<< "$($String.split '*' 'Sheldon * Leonard * Howard * Raj')"
  args=$($Test.array_diff result expected)
  $Test.it 'Should pass if a literal asterisk is escaped on split.' <<EOF
    [ -z "$args" ]
EOF
}

# shellcheck disable=SC2086
# shellcheck disable=SC2154
StringTest.testJoin() {
  local result
  local expected

  expected='Sheldon % Leonard % Howard % Raj'
  result=$($String.join ' % ' Sheldon Leonard Howard Raj)
  $Test.it "Should pass with literal '%' as the glue." <<EOF
    [ "$result" = "$expected" ]
EOF

  expected='Sheldon %% Leonard %% Howard %% Raj'
  result=$($String.join ' %% ' Sheldon Leonard Howard Raj)
  $Test.it "Should pass with two literal '%' as the glue." <<EOF
    [ "$result" = "$expected" ]
EOF

  expected='Amy & Sheldon'
  result=$($String.join ' & ' Amy Sheldon)
  $Test.it 'Should pass with literal & as the glue.' <<EOF
    [ "$result" = "$expected" ]
EOF

  expected='Amy  Sheldon'
  result=$($String.join '  ' Amy Sheldon)
  $Test.it 'Should pass with two spaces as the glue.' <<EOF
    [ "$result" = "$expected" ]
EOF

  expected='Sheldon/Leonard/Howard/Raj'
  result=$($String.join '/' Sheldon Leonard Howard Raj)
  $Test.it 'Should pass without spaces around glue.' <<EOF
    [ "$result" = "$expected" ]
EOF

  expected='Sheldon'
  result=$($String.join ' & ' Sheldon)
  $Test.it 'Should pass if a single arg simply returns the arg itself.' <<EOF
    [ "$result" = "$expected" ]
EOF
}

# shellcheck disable=SC2086
# shellcheck disable=SC2154
StringTest.testInsert() {
  local result
  local expected
  local -A data
  local template
  local -A options

  # shellcheck disable=SC2034
  data=(
    ['who']='Housni'
    ['domain']='housni.org'
    ['filename']='backup.sql'
  );

  template='/var/www/{{ who}}/{{ domain }}/backup/database/{{filename}}'
  expected='/var/www/Housni/housni.org/backup/database/backup.sql'
  result=$($String.insert "$template" data)
  $Test.it 'Should pass if placeholders are replaced properly.' <<EOF
    [ "$result" = "$expected" ]
EOF

  options=(
    ['before']='<?'
    ['after']='?>'
  )
  template='/var/www/<?who?>/<?domain?>/backup/database/<?filename?>'
  expected='/var/www/Housni/housni.org/backup/database/backup.sql'
  result=$($String.insert "$template" data options)
  $Test.it 'Should pass if custom before and after string for placeholders work.' <<EOF
    [ "$result" = "$expected" ]
EOF

  options=(
    ['before']='<?'
  )
  template='/var/www/<?who}}/<?domain}}/backup/database/<?filename}}'
  expected='/var/www/Housni/housni.org/backup/database/backup.sql'
  result=$($String.insert "$template" data options)
  $Test.it 'Should pass if custom before string for placeholders work.' <<EOF
    [ "$result" = "$expected" ]
EOF

  # shellcheck disable=SC2034
  options=(
    ['after']=']'
  )
  template='/var/www/{{who]/{{domain]/backup/database/{{filename]'
  expected='/var/www/Housni/housni.org/backup/database/backup.sql'
  result=$($String.insert "$template" data options)
  $Test.it 'Should pass if custom after string for placeholders work.' <<EOF
    [ "$result" = "$expected" ]
EOF
}

# shellcheck disable=SC2086
# shellcheck disable=SC2154
StringTest.testLower() {
  local expected
  local result

  expected='bazinga!'
  result=$($String.lower "BAZINGA!")
  $Test.it 'Should pass if text is lower case.' <<EOF
    [ "$result" = "$expected" ]
EOF

  expected='BaZiNGa!'
  result=$($String.lower "BAZINGA!" AEIOU)
  $Test.it 'Should pass if only vowels are lower case.' <<EOF
    [ "$result" = "$expected" ]
EOF
}

# shellcheck disable=SC2086
# shellcheck disable=SC2154
StringTest.testUpper() {
  local expected
  local result

  expected='BAZINGA!'
  result=$($String.upper "bazinga!")
  $Test.it 'Should pass if text is upper case.' <<EOF
    [ "$result" = "$expected" ]
EOF

  expected='bAzIngA!'
  result=$($String.upper "bazinga!" aeiou)
  $Test.it 'Should pass if only vowels are upper case.' <<EOF
    [ "$result" = "$expected" ]
EOF
}

# shellcheck disable=SC2086
# shellcheck disable=SC2154
StringTest.testSwapcase() {
  local expected
  local result

  expected="I am one with The Force"
  result=$($String.swapcase "i AM ONE WITH tHE fORCE")
  $Test.it 'Should pass if text case is toggled.' <<EOF
    [ "$result" = "$expected" ]
EOF

  expected="I am one with The Force"
  result=$($String.swapcase "i AM ONE WITH tHE fORCE")
  $Test.it 'Should pass if text case is toggled.' <<EOF
    [ "$result" = "$expected" ]
EOF
}

# shellcheck disable=SC2086
# shellcheck disable=SC2154
StringTest.testCapitalize() {
  local expected
  local result

  expected="I am one with The Force"
  result=$($String.capitalize "i am one with The Force")
  $Test.it 'Should pass if the first letter is upper case.' <<EOF
    [ "$result" = "$expected" ]
EOF

  expected="I am one with The Force"
  result=$($String.capitalize "I am one with The Force")
  $Test.it 'Should pass if the first letter remains upper case.' <<EOF
    [ "$result" = "$expected" ]
EOF
}

# shellcheck disable=SC2086
# shellcheck disable=SC2154
StringTest.testTitle() {
  local expected
  local result

  expected="I Am One With The Force"
  result=$($String.title "I am one with The Force")
  $Test.it 'Should pass if the first letter of each word is upper case.' <<EOF
    [ "$result" = "$expected" ]
EOF

  expected="I Am One With The Force"
  result=$($String.title "i am one with the force")
  $Test.it 'Should pass if the first letter of each word is upper case.' <<EOF
    [ "$result" = "$expected" ]
EOF
}

# shellcheck disable=SC2086
# shellcheck disable=SC2154
StringTest.testLength() {
  local -i expected
  local -i result

  expected=8
  result=$($String.length "Bazinga!")
  $Test.it "Should pass if the lenth of the word $epxected characters long." <<EOF
    [ "$result" = "$expected" ]
EOF
}