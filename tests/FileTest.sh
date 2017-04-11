FileTest.setUp() {
  use Sheldon.Util.File as File

  FILE_SHELDON_TEMP_FILE="$(mktemp)"
  FILE_SHELDON_TEMP_DIR="$(mktemp -d)"
  FILE_SHELDON_TEMP_SYMLINK="/tmp/FileTest.symlink.${RANDOM}"
  $(ln -s $FILE_SHELDON_TEMP_FILE $FILE_SHELDON_TEMP_SYMLINK)
  FILE_SHELDON_TEMP_SOCKET="/tmp/FileTest.sock.${RANDOM}"
  $(mknod $FILE_SHELDON_TEMP_SOCKET p)
}

FileTest.tearDown() {
  rm -rf "$FILE_SHELDON_TEMP_FILE" "$FILE_SHELDON_TEMP_DIR" "$FILE_SHELDON_TEMP_SYMLINK" "$FILE_SHELDON_TEMP_SOCKET"
}


FileTest.testExists?() {
  local result
  local expected
  local arg

  arg="$FILE_SHELDON_TEMP_FILE"
  expected='true'
  $File.exists? =result "$arg"
  $Test.it 'File.exists?: Should pass if a file exists.' <<EOF
    [ "$result" = "$expected" ]
EOF

  arg="$FILE_SHELDON_TEMP_DIR"
  expected='true'
  $File.exists? =result "$arg"
  $Test.it 'File.exists?: Should pass if a dir exists.' <<EOF
    [ "$result" = "$expected" ]
EOF
}

FileTest.testIsDir?() {
  local result
  local expected
  local arg

  arg="$FILE_SHELDON_TEMP_FILE"
  expected='false'
  $File.isDir? =result "$arg"
  $Test.it 'File.isDir?: Should pass if file is a regular file.' <<EOF
    [ "$result" = "$expected" ]
EOF

  arg="$FILE_SHELDON_TEMP_DIR"
  expected='true'
  $File.isDir? =result "$arg"
  $Test.it 'File.isDir?: Should pass if file is a dir.' <<EOF
    [ "$result" = "$expected" ]
EOF
}

FileTest.testIsFile?() {
  local result
  local expected
  local arg

  arg="$FILE_SHELDON_TEMP_FILE"
  expected='true'
  $File.isFile? =result "$arg"
  $Test.it 'File.isFile?: Should pass if file is a regular file.' <<EOF
    [ "$result" = "$expected" ]
EOF

  arg="$FILE_SHELDON_TEMP_DIR"
  expected='false'
  $File.isFile? =result "$arg"
  $Test.it 'File.isFile?: Should pass if file is a dir.' <<EOF
    [ "$result" = "$expected" ]
EOF
}

FileTest.testIsLink?() {
  local result
  local expected
  local arg

  arg="$FILE_SHELDON_TEMP_SYMLINK"
  expected='true'
  $File.isLink? =result "$arg"
  $Test.it 'File.isLink?: Should pass if file is a symlink.' <<EOF
    [ "$result" = "$expected" ]
EOF

  arg="$FILE_SHELDON_TEMP_DIR"
  expected='false'
  $File.isLink? =result "$arg"
  $Test.it 'File.isLink?: Should pass if file is a dir.' <<EOF
    [ "$result" = "$expected" ]
EOF

  arg="$FILE_SHELDON_TEMP_FILE"
  expected='false'
  $File.isLink? =result "$arg"
  $Test.it 'File.isLink?: Should pass if file is a regular file.' <<EOF
    [ "$result" = "$expected" ]
EOF
}

# FileTest.testIsSocket?() {
#   local result
#   local expected
#   local arg

#   arg="$FILE_SHELDON_TEMP_SOCKET"
#   expected='true'
#   $File.isSocket? =result "$arg"
#   $Test.it 'File.isSocket?: Should pass if file is a socket.' <<EOF
#     [ "$result" = "$expected" ]
# EOF

# exit
#   arg="$FILE_SHELDON_TEMP_DIR"
#   expected='false'
#   $File.isLink? =result "$arg"
#   $Test.it 'File.isSocket?: Should pass if file is a dir.' <<EOF
#     [ "$result" = "$expected" ]
# EOF
# }