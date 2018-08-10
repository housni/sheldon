#!/usr/bin/env bash

FileTest.setUp() {
  import Sheldon.Util.File as File

  FILE_SHELDON_TEMP_FILE="$(mktemp -t sheldon.XXXXXXXXXX)"
  FILE_SHELDON_TEMP_DIR="$(mktemp -d -t sheldon.XXXXXXXXXX)"
  FILE_SHELDON_TEMP_SYMLINK="$(mktemp -u -t Sheldon.FileTest.symlink.XXXXXXXXXX)"
  ln -s "${FILE_SHELDON_TEMP_FILE}" "${FILE_SHELDON_TEMP_SYMLINK}"
  FILE_SHELDON_TEMP_PIPE="$(mktemp -u -t Sheldon.FileTest.pipe.XXXXXXXXXX)"
  mknod $FILE_SHELDON_TEMP_PIPE p
}

FileTest.tearDown() {
  rm -rf "$FILE_SHELDON_TEMP_FILE" "$FILE_SHELDON_TEMP_DIR" "$FILE_SHELDON_TEMP_SYMLINK" "$FILE_SHELDON_TEMP_SOCKET"
}

# shellcheck disable=SC2154
# shellcheck disable=SC2086
FileTest.testExists?() {
  local result
  local -i expected
  local arg

  arg="$FILE_SHELDON_TEMP_FILE"
  expected=0
  # shellcheck disable=SC2211
  result=$($File.exists? "$arg")
  $Test.it 'File.exists?: Should pass if a file exists.' <<EOF
    [ "$result" -eq "$expected" ]
EOF

  arg="$FILE_SHELDON_TEMP_DIR"
  expected=0
  # shellcheck disable=SC2211
  result=$($File.exists? "$arg")
  $Test.it 'File.exists?: Should pass if a dir exists.' <<EOF
    [ "$result" -eq "$expected" ]
EOF
}

# shellcheck disable=SC2154
# shellcheck disable=SC2086
FileTest.testIsDir?() {
  local result
  local expected
  local arg

  arg="$FILE_SHELDON_TEMP_FILE"
  expected=1
  # shellcheck disable=SC2211
  result=$($File.isDir? "$arg")
  $Test.it 'File.isDir?: Should pass if file is not a dir.' <<EOF
    [ "$result" -eq "$expected" ]
EOF

  arg="$FILE_SHELDON_TEMP_DIR"
  expected=0
  # shellcheck disable=SC2211
  result=$($File.isDir? "$arg")
  $Test.it 'File.isDir?: Should pass if file is a dir.' <<EOF
    [ "$result" -eq "$expected" ]
EOF
}

# shellcheck disable=SC2154
# shellcheck disable=SC2086
FileTest.testIsFile?() {
  local result
  local expected
  local arg

  arg="$FILE_SHELDON_TEMP_FILE"
  expected=0
  # shellcheck disable=SC2211
  result=$($File.isFile? "$arg")
  $Test.it 'File.isFile?: Should pass if file is a regular file.' <<EOF
    [ "$result" -eq "$expected" ]
EOF

  arg="$FILE_SHELDON_TEMP_DIR"
  expected=1
  # shellcheck disable=SC2211
  result=$($File.isFile? "$arg")
  $Test.it 'File.isFile?: Should pass if file is a dir.' <<EOF
    [ "$result" -eq "$expected" ]
EOF
}

# shellcheck disable=SC2154
# shellcheck disable=SC2086
FileTest.testIsLink?() {
  local result
  local expected
  local arg

  arg="$FILE_SHELDON_TEMP_SYMLINK"
  expected=0
  # shellcheck disable=SC2211
  result=$($File.isLink? "$arg")
  $Test.it 'File.isLink?: Should pass if file is a symlink.' <<EOF
    [ "$result" -eq "$expected" ]
EOF

  arg="$FILE_SHELDON_TEMP_DIR"
  expected=1
  # shellcheck disable=SC2211
  result=$($File.isLink? "$arg")
  $Test.it 'File.isLink?: Should pass if file is a dir.' <<EOF
    [[ "$result" -eq "$expected" ]]
EOF

  arg="$FILE_SHELDON_TEMP_FILE"
  expected=1
  # shellcheck disable=SC2211
  result=$($File.isLink? "$arg")
  $Test.it 'File.isLink?: Should pass if file is a regular file.' <<EOF
    [[ "$result" -eq "$expected" ]]
EOF
}

# shellcheck disable=SC2154
# shellcheck disable=SC2086
FileTest.testIsPipe?() {
  local result
  local expected
  local arg

  arg="$FILE_SHELDON_TEMP_PIPE"
  expected=0
  # shellcheck disable=SC2211
  result=$($File.isPipe? "$arg")
  $Test.it 'File.isPipe?: Should pass if file is a pipe.' <<EOF
    [[ "$result" -eq "$expected" ]]
EOF

  arg="$FILE_SHELDON_TEMP_DIR"
  expected=1
  # shellcheck disable=SC2211
  result=$($File.isPipe? "$arg")
  $Test.it 'File.isPipe?: Should pass if file is a dir.' <<EOF
    [ "$result" -eq "$expected" ]
EOF
}