StringTest.setUp() {
  use Sheldon.Util.String as String
}

StringTest.tearDown() {
  :
}


StringTest.testExplode() {
  local result
  local expected
  local args

  expected=( var www html )
  $String.explode =result '/' '/var/www/html'
  $Test.array_diff =args result expected
  $Test.it 'String.explode: Should pass if a string is exploded correctly.' <<EOF
    [ -z "$args" ]
EOF

  expected=( Sheldon Leonard Howard Raj )
  $String.explode =result '*' 'Sheldon * Leonard * Howard * Raj'
  $Test.array_diff =args result expected
  $Test.it 'String.explode: Should pass if a literal asterisk is escaped on explode.' <<EOF
    [ -z "$args" ]
EOF
}


StringTest.testJoin() {
  local result
  local expected

  expected='Sheldon % Leonard % Howard % Raj'
  $String.join =result ' % ' Sheldon Leonard Howard Raj
  $Test.it "String.join: Should pass with literal '%' as the glue." <<EOF
    [ "$result" = "$expected" ]
EOF

  expected='Sheldon %% Leonard %% Howard %% Raj'
  $String.join =result ' %% ' Sheldon Leonard Howard Raj
  $Test.it "String.join: Should pass with two literal '%' as the glue." <<EOF
    [ "$result" = "$expected" ]
EOF

  expected='Amy & Sheldon'
  $String.join =result ' & ' Amy Sheldon
  $Test.it 'String.join: Should pass with literal & as the glue.' <<EOF
    [ "$result" = "$expected" ]
EOF

  expected='Amy  Sheldon'
  $String.join =result '  ' Amy Sheldon
  $Test.it 'String.join: Should pass with two spaces as the glue.' <<EOF
    [ "$result" = "$expected" ]
EOF

  expected='Sheldon/Leonard/Howard/Raj'
  $String.join =result '/' Sheldon Leonard Howard Raj
  $Test.it 'String.join: Should pass without spaces around glue.' <<EOF
    [ "$result" = "$expected" ]
EOF

  expected='Sheldon'
  $String.join =result ' & ' Sheldon
  $Test.it 'String.join: Should pass if a single arg simply returns the arg itself.' <<EOF
    [ "$result" = "$expected" ]
EOF
}


StringTest.testInsert() {
  local result
  local expected
  local -A data
  local template

  data=(
   ['who']='Housni'
   ['domain']='housni.org'
   ['filename']='backup.sql'
  );

  template='/var/www/{:who}/{:domain}/backup/database/{:filename}'
  expected='/var/www/Housni/housni.org/backup/database/backup.sql'
  $String.insert =result "$template" data
  $Test.it 'String.insert: Should pass placeholders are replaced properly.' <<EOF
    [ "$result" = "$expected" ]
EOF

  template='/var/www/<?who?>/<?domain?>/backup/database/<?filename?>'
  expected='/var/www/Housni/housni.org/backup/database/backup.sql'
  $String.insert =result "$template" data -b '<?' -a '?>'
  $Test.it 'String.insert: Should pass if custom before and after string for placeholders work.' <<EOF
    [ "$result" = "$expected" ]
EOF

  template='/var/www/<?who}/<?domain}/backup/database/<?filename}'
  expected='/var/www/Housni/housni.org/backup/database/backup.sql'
  $String.insert =result "$template" data -b '<?'
  $Test.it 'String.insert: Should pass if custom before string for placeholders work.' <<EOF
    [ "$result" = "$expected" ]
EOF

  template='/var/www/{:who]/{:domain]/backup/database/{:filename]'
  expected='/var/www/Housni/housni.org/backup/database/backup.sql'
  $String.insert =result "$template" data -a ']'
  $Test.it 'String.insert: Should pass if custom after string for placeholders work.' <<EOF
    [ "$result" = "$expected" ]
EOF
}
