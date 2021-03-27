= build lazy (potentially infinite) dynamic sequences

10 [1,b] 3 nth puts
= outputs, ergh...3

'linear-sequence [  = ( -- sequence )
  [ 1 [ 1 next-linear ] ]
] def

'next-linear [  = ( number -- next-number sequence )
  1 + dup 'next-linear  = next-number next-number 'next-linear
  curry                 = next-number [ next-number next-linear ]
] def

linear-sequence 5 nth puts
