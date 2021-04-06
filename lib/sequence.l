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

= ( sequence index -- value )
'nth [
  [ head-tail swap ] dip     = seq value index
  dup 1 is           = seq value index last?
  [ drop nip ]
  [ 1 - nip nth ]
  if
] def


== Sequence builders

= ( initial 'next-quote 'until-quote -- sequence )
'make-sequence [
  compose-next-until
  quote
  'next-until
  compose compose
] def

'compose-next-until [
  [ 'dup ] 2dip    = initial 'dup next-quote until-quote
  [ 'dup ] dip     = initial 'dup next-quote
  compose compose compose  = initial [ dup next dup until ]
] def

= ( initial quote -- sequence )
'next-until [
  dup 'call dip    = initial next-value last? quote
  swap             = initial next-value quote last?
  [ drop 'false curry ]
  [ [ next-until ] curry curry ]
  if
] def


== Ranges

= ( bound -- sequence )
'[1,b] [
  'is curry [ 1 [ 1 + ] ] dip make-sequence
] def
