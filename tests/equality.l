'test use

'false 'false assert-is
'false false assert-is

'false 'true assert-is-not
'true 'false assert-is-not
'false 'ubiquitous assert-is-not
'true 'ubiquitous assert-is-not
'true 'true assert-is

'true not not 'true assert-is
'false not 'true assert-is

[ 1 2 ] [ 1 2 ] assert-is
[ 1 ] [ 1 ] assert-is
[ 1 ] [ 33 ] assert-is-not
[ 1 2 ] [ 1 1 ] assert-is-not

[ 'a 'b ] [ 'a 'b ] assert-is
[ 'a 'b ] [ 'a 'c ] assert-is-not

"foo" "foo" assert-is
"foo" "bar" assert-is-not

0 false assert-is-not
1 false assert-is-not
1 'true assert-is-not
false 0 assert-is-not
false 1 assert-is-not
'true 1 assert-is-not
"foo" false assert-is-not
