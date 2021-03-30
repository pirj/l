== Sequence combinators

= ( sequence -- value-or-values sequence-or-false )
'head-tail [ call ] def

= ( sequence quote -- result )
'reduce [ [ head-tail swap ] dip fold ] def

= ( seq value quote ( x y -- z ) -- result )
'fold [ 'swap dip each ] def

= ( sequence quote -- )
'each [
  [ head-tail swap ]
  dip       = sequence value quote
  swap      = sequence quote value
  over      = sequence quote value quote
  2swap     = value quote sequence quote
  'call 2dip = sequence quote
  [ each ]  = sequence quote [ each ]
  curry     = sequence [ quote each ]
  over      = sequence [ quote each ] sequence
  swap      = sequence sequence [ quote each ]
  'drop     = sequence sequence [ quote each ] 'drop
  if        = sequence quote each / 'false
] def

= build a range sequence
'[1,b] [  = ( bound -- sequence )
  'false [1,b]i
] def

'[1,b]i [  = internal ( b sequence -- b-1 sequence-with-b )
  2dup          = b seq b seq
  drop          = b seq b
  swap          = b b seq
  quote curry   = b new-seq
  over          = b new-seq b
  [ 1 - ] 2dip  = b-1 new-seq b
  1 is not      = b-1 new-seq last-iteration?
  '[1,b]i       = b-1 new-seq last-iteration? <recursive-call>
  'nip
  if
] def

= ( sequence index -- value )
'nth [
  [ head-tail swap ] dip     = seq value index
  dup 1 is           = seq value index last?
  [ drop nip ]
  [ 1 - nip nth ]
  if
] def
