[ sequence test ] use

= ( value quote -- value initial-index quote-with-index-increment )
= transforms quote  = ( x i -- z )
=   [ * ]
= to quote  = quote-with-index-increment ( x i -- x z i' )
=   [
=     [ * ] 2keep  = z x i
=     'swap dip    = x z i
=     1 +          = x z i'
=   ]
'with-index [
  [ 2 ] dip  = value initial-index quote
  [ 2keep 'swap dip 1 + ] curry
] def

'next2 [  = ( value index quote -- value sequence )
  'call keep             = value next-value next-index quote
  'next2 'curry 3 times  = value [ next-value next-index quote next ]
] def

= factorial(n) = n * factorial(n-1), 1 1 2 6 24 120 720 5040
'factorial-sequence [  = ( -- sequence )
  [ 1 '* with-index next2 ]
] def

factorial-sequence 7 nth
  5040 assert-is


= ( value quote -- value value quote-keeping-previous )
'with-previous [
  'dup dip  =  value value quote
  [ keep swap 'dup dip ] curry
] def
= transform quote  = ( x y -- z )
=   [ + ]
= to quote  = quote-keeping-previous ( x y -- y y z )
= [
=   [ + ] keep  = z y
=   swap        = y z
=   'dup dip    = y y z
= ]

= fib(n) = fib(n-1) + fib(n-2), 1 2 3 5 8 13 21 34 55 89
'fibonacci-sequence [  = ( -- sequence )
  [ 1 '+ with-previous next2 ]
] def

fibonacci-sequence 10 nth
  89 assert-is
