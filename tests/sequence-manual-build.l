[ sequence test ] use

= build lazy (potentially infinite) dynamic sequences

'linear-sequence [  = ( -- sequence )
  [ 1 next-linear ]
] def

'next-linear [  = ( number -- number sequence )
  dup 1 + 'next-linear  = number next-number 'next-linear
  curry                 = number [ next-number next-linear ]
] def

linear-sequence 5 nth 5 assert-is


'monotonic-sequence [  = ( -- sequence )
  [ 100 next-monotonic ]
] def

'next-monotonic [  = ( number -- number sequence )
  dup 'next-monotonic  = number number 'next-monotonic
  curry                = number [ number next-monotonic ]
] def

monotonic-sequence 10 nth 100 assert-is
= they are all the same
