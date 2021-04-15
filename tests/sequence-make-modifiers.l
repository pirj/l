[ sequence test ] use

'next2 [  = ( value index quote -- value sequence )
  'call keep             = value next-value next-index quote
  'next2 'curry 3 times  = value [ next-value next-index quote next ]
] def

'make-s [  = ( initial-value initial-other quote -- sequence )
  'next2 'curry 3 times
] def


= ( value quote ( x i -- z ) -- value initial-index quote-with-index-increment ( x i -- x z i' ) )
'with-index [
  [ 2 ] dip  = value initial-index quote
  [ [ 1 + ] 2bi 'swap dip ] curry
] def

= factorial(n) = n * factorial(n-1), 1 1 2 6 24 120 720 5040
'factorial-sequence [  = ( -- sequence )
  1 '* with-index make-s
] def

factorial-sequence 7 nth
  5040 assert-is


= ( previous-value value quote ( x y -- z ) -- previous-value value quote-keeping-previous ( x y -- y y z ) )
'with-previous [
  [ keep swap 'dup dip ] curry
] def

= fib(n) = fib(n-1) + fib(n-2), 1 1 2 3 5 8 13 21 34 55
'fibonacci-sequence [  = ( -- sequence )
  0 1 '+ with-previous make-s
] def

fibonacci-sequence 10 nth
  55 assert-is
