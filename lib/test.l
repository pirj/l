= make sure values are equal
'assert-is [
  2dup [ is not ] 2dip pick [ 'puts 2 times drop 'expected-to-be-equal fail ] [ 2drop drop ] if
] def

= make sure values are not equal
'assert-is-not [
  2dup 'is 2dip pick [ 'puts 2 times drop 'expected-to-be-different fail ] [ 2drop drop ] if
] def
