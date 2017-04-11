ArrayTest.setUp() {
  use Sheldon.Util.Array as Array
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
  $Test.array_diff =result arg1 expected
  $Test.it 'Array.push: Should pass if elements are pushed with individual arguments.' <<EOF
    [ -z "$result" ]
EOF

  arg1=( var www )
  arg2=( html Housni 'housni.org' )
  expected=( var www html Housni 'housni.org' )
  $Array.push arg1 arg2
  $Test.array_diff =result arg1 expected
  $Test.it 'Array.push: Should pass if elements are pushed with an array of arguments.' <<EOF
    [ -z "$result" ]
EOF
}


ArrayTest.testPop() {
  local result
  local -a expected
  local -a args
  local popped

  args=( var www html )
  expected=( var www )
  $Array.pop =popped args
  $Test.array_diff =result args expected
  $Test.it 'Array.pop: Should pass if an element is popped off the end of the array.' <<EOF
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
  $Test.array_diff =result arg1 expected
  $Test.it 'Array.unshift: Should pass if elements are unshifted with individual arguments.' <<EOF
    [ -z "$result" ]
EOF

  arg1=( Housni 'housni.org' public_html )
  arg2=( var www html )
  expected=( var www html Housni 'housni.org' public_html )
  $Array.unshift arg1 arg2
  $Test.array_diff =result arg1 expected
  $Test.it 'Array.unshift: Should pass if elements are unshifted with an array of arguments.' <<EOF
    [ -z "$result" ]
EOF
}

ArrayTest.testShift() {
  local result
  local expected
  local -a arg1
  local shifted

  arg1=( var www html )
  expected=( www html )
  $Array.shift =shifted arg1
  $Test.array_diff =result arg1 expected
  $Test.it 'Array.shift: Should pass if an element shifted.' <<EOF
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
  $Array.first =result args
  $Test.it 'Array.first: Should pass the result is the first element.' <<EOF
    [ "$result" = "$expected" ]
EOF
}

ArrayTest.testLast() {
  local result
  local expected
  local -a args

  args=( var www html )
  expected='html'
  $Array.last =result args
  $Test.it 'Array.last: Should pass the result is the last element.' <<EOF
    [ "$result" = "$expected" ]
EOF
}

ArrayTest.testImplode() {
  local result
  local expected
  local -a args

  args=("/home" housni Desktop)
  expected='/home/housni/Desktop'
  $Array.implode =result '/' args
  $Test.it 'Array.implode: Should pass if elements are imploded together.' <<EOF
    [ "$result" = "$expected" ]
EOF

  args=(home housni Desktop)
  expected='home - housni - Desktop'
  $Array.implode =result ' - ' args
  $Test.it 'Array.implode: Should pass if elements are imploded together with a character surrounded by spaces.' <<EOF
    [ "$result" = "$expected" ]
EOF

  args=(home housni Desktop)
  expected='home%housni%Desktop'
  $Array.implode =result '%' args
  $Test.it "Array.implode: Should pass if elements are imploded together with a literal '%'." <<EOF
    [ "$result" = "$expected" ]
EOF
}