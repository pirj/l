'test use

'false 'false is assert
'false false is assert

'false 'true is not assert
'true 'false is not assert
'false 'ubiquitous is not assert
'true 'ubiquitous is not assert

'true not not assert

'false not assert

[ 1 2 ] [ 1 2 ] is assert
[ 1 ] [ 1 ] is assert
[ 1 ] [ 33 ] is not assert
[ 1 2 ] [ 1 1 ] is not assert

[ 'a 'b ] [ 'a 'b ] is assert
[ 'a 'b ] [ 'a 'c ] is not assert
