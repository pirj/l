= build lazy (potentially infinite) dynamic sequences

10 [1,b] 3 nth puts
= outputs, ergh...3

'linear-sequence [  = ( -- sequence )
  [ 1 next-linear ]
] def

'next-linear [  = ( number -- number sequence )
  dup 1 + 'next-linear  = number next-number 'next-linear
  curry                 = number [ next-number next-linear ]
] def

linear-sequence 5 nth puts

'monotonic-sequence [  = ( -- sequence )
  [ 100 next-monotonic ]
] def

'next-monotonic [  = ( number -- number sequence )
  dup 'next-monotonic  = number number 'next-monotonic
  curry                = number [ number next-monotonic ]
] def

monotonic-sequence 10 nth puts
= they are all the same, outputs 100
