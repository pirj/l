[ sequence test ] use

'linear-sequence [  = ( -- sequence )
  [ 1 [ 1 + ] next ]
] def

'next [  = ( value quote -- value sequence )
  2dup call     = value quote next-value
  swap          = value next-value quote
  'next 'curry 2 times  = value [ next-value quote next ]
] def

= ( n -- n+1 )
'with-index-1 [
  1 [ 1 + ]
] def

= in stack on the first iteration
= 1  = prev-value
= 1  = prev-index
= [
=   [ 1 + nip ]  = with-index ( x i - i' )
=   [ drop ]     = with-previous ( x a - x )
= ]
= 'quote

= ( previous-value value quote ( x y -- z ) -- previous-value value quote-keeping-previous ( x y -- y y z ) )
'with-previous [
  [ keep swap 'dup dip ] curry
] def


= factorial(n) = n * factorial(n-1), 1 1 2 6 24 120 720 5040
'factorial-sequence [  = ( -- sequence )
  1 '* with-index make-s
] def

factorial-sequence 7 nth
  5040 assert-is


= fib(n) = fib(n-1) + fib(n-2), 1 1 2 3 5 8 13 21 34 55
'fibonacci-sequence [  = ( -- sequence )
  0 1 '+ with-previous make-s
] def

fibonacci-sequence 10 nth
  55 assert-is


= = f(n) = n + f(n-1) + f(n-2), 0 1 - 3 6 10 15 21 28 35
= 'some-seq [  = ( -- sequence )
=   = 0 1 [ + + ] with-previous with-index make-s
=   [ 0 1 [ + + ] with-previous with-index next3 ]
= ] def

= 0 1 1
= 
= with-index pushes the initial index
= 
= 0 1 1 [ 
