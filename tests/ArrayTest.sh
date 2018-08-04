ArrayTest.setUp() {
  import Sheldon.Util.Array as Array
}

ArrayTest.tearDown() {
  :
}

ArrayTest.testPush() {
  local result
  local -a expected
  local -a arg1
  local -a arg2

  arg1=( var www )
  expected=( var www html Housni 'housni.org' )
  $Array.push arg1 html Housni 'housni.org'
  $Test.it 'Should pass if elements are pushed with individual arguments.' <<EOF
    [[ 0 -eq $($Test.array_equal? arg1 expected) ]]
EOF

  arg1=( var www )
  arg2=( html Housni 'housni.org' )
  expected=( var www html Housni 'housni.org' )
  $Array.push arg1 arg2
  $Test.it 'Should pass if elements are pushed with an array of arguments.' <<EOF
    [[ 0 -eq $($Test.array_equal? arg1 expected) ]]
EOF
}

ArrayTest.testPop() {
  local result
  local -a expected
  local -a args
  local popped

  args=( var www html )
  expected=( var www )
  popped=$($Array.pop args)
  result=$($Test.array_diff args expected)

  $Test.it 'Should pass if an element is popped off the end of the array.' \
    skip 'This has not been implemented.' <<EOF
      [ -z "$result" ]
      [ "$popped" = 'html' ]
EOF

  $Test.it 'Should pass if an element is popped off the end of the array.' \
    skip 'This has not been implemented.' <<EOF
      [ -z "$result" ]
      [ "$popped" = 'html' ]
EOF
}

ArrayTest.testUnshift() {
  local result
  local -a expected
  local -a arg1
  local -a arg2

  arg1=( Housni 'housni.org' public_html )
  expected=( var www html Housni 'housni.org' public_html )
  $Array.unshift arg1 var www html
  result=$($Test.array_diff arg1 expected)
  $Test.it 'Should pass if elements are unshifted with individual arguments.' <<EOF
    [ -z "$result" ]
EOF

  arg1=( Housni 'housni.org' public_html )
  arg2=( var www html )
  expected=( var www html Housni 'housni.org' public_html )
  $Array.unshift arg1 arg2
  result=$($Test.array_diff arg1 expected)
  $Test.it 'Should pass if elements are unshifted with an array of arguments.' <<EOF
    [ -z "$result" ]
EOF
}

ArrayTest.testShift() {
  local result
  local -a expected
  local -a arg1
  local shifted

  arg1=( var www html )
  expected=( www html )
  shifted=$($Array.shift arg1)
  result=$($Test.array_diff arg1 expected)
  $Test.it 'Should pass if an element shifted.' \
    skip 'This has not been implemented.' <<EOF
      [ -z "$result" ]
      [ "$shifted" = 'var' ]
EOF
}

ArrayTest.testFirst() {
  local result
  local expected
  local -a args

  args=( var www html )
  expected='var'
  result=$($Array.first args)
  $Test.it 'Should pass if the result is the first element.' <<EOF
    [ "$result" = "$expected" ]
EOF
}

ArrayTest.testLast() {
  local result
  local expected
  local -a args

  args=( var www html )
  expected='html'
  result=$($Array.last args)
  $Test.it 'Should pass the result in the last element.' <<EOF
    [ "$result" = "$expected" ]
EOF
}

ArrayTest.testImplode() {
  local result
  local expected
  local -a args

  args=("/home" housni Desktop)
  expected='/home/housni/Desktop'
  result=$($Array.implode '/' args)
  $Test.it 'Should pass if elements are imploded together.' <<EOF
    [ "$result" = "$expected" ]
EOF

  args=(home housni Desktop)
  expected='home - housni - Desktop'
  result=$($Array.implode ' - ' args)
  $Test.it 'Should pass if elements are imploded together with a character surrounded by spaces.' <<EOF
    [ "$result" = "$expected" ]
EOF

  args=(home housni Desktop)
  expected='home%housni%Desktop'
  result=$($Array.implode '%' args)
  $Test.it "Should pass if elements are imploded together with a literal '%'." <<EOF
    [ "$result" = "$expected" ]
EOF
}

ArrayTest.testUpdate() {
  local -A expected
  local -A defaults
  local -A options

  defaults=( ["key1"]="val1" ["key2"]="val2" ["key3"]="val3" )
  options=(                  ["key2"]="custom value" )
  expected=( ["key1"]="val1" ["key2"]="custom value" ["key3"]="val3" )
  $Array.update defaults options
  difference=$($Test.array_diff defaults expected)
  $Test.it 'Should pass if custom array element overwrote the default one.' <<EOF
    [ -z "$difference" ]
    [ "$defaults" = "$expected" ]
EOF
}