[ sequence test ] use

= build arbitrary sequences given a quote

'linear-sequence [  = ( -- sequence )
  [ 1 [ 1 + ] next ]
] def

'next [  = ( value quote -- value sequence )
  2dup call     = value quote next-value
  swap          = value next-value quote
  'next 2curry  = value [ next-value quote next ]
] def

linear-sequence 5 nth 5 is assert


'next-with-index [  = ( index value quote -- value sequence )
  3dup call                = index value quote next-value
  [ swap 1 + ] 2dip        = value next-index quote next-value
  swap                     = value next-index next-value quote
  'next-with-index 3curry  = value [ next-index next-value quote next ]
] def

= factorial(n) = n * factorial(n-1), 1 1 2 6 24 120 720 5040
'factorial-sequence [  = ( -- sequence )
  [ 2 1 '* next-with-index ]
] def

factorial-sequence 7 nth 5040 is assert
= well, you can't call it as `0 nth`, the sequence starts with its first element which is for factorial(1)


'next-with-previous [  = ( previous-value value quote -- value sequence )
  3dup call                   = previous-value value quote next-value
  [ nip dup ] 2dip            = value value quote next-value
  swap                        = value value next-value quote
  'next-with-previous 3curry  = value [ value next-value quote next ]
] def

= fib(n) = fib(n-1) + fib(n-2), 1 1 2 3 5 8 13 21 34 55
'fibonacci-sequence [  = ( -- sequence )
  [ 0 1 '+ next-with-previous ]
] def

fibonacci-sequence 10 nth 55 is assert
= Again, the sequence starts with first element = 1, not 0. But the initial value of the sequence is set to 0
