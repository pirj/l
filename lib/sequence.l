== Sequence combinators

= TODO: change the quote to be first?
= + when running a quote against values, e.g. in `map`, values are at the top
=   of the stack. And once they are processed, a quote is there, quote is not
=   necessary to call over with a `dip`.
= - shuffling needed to put the quote to the bottom

= Sequence is a nested structure of quotes.
= Each quote has one or several values, and also one quote.
= An empty quote (`[ ]`) denotes the end of the sequence.
= This limits to a sequential access to elements, but allows
= for lazy, potentially endless sequences.

= ( sequence -- value-or-values sequence )
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

'infinite [ [ drop false ] ] def


== Ranges

= ( initial bound -- sequence )
'[a,b] [
  'is curry [ [ 1 + ] ] dip  = a [ 1 + ] [ b is ]
  make-sequence
] def

= ( bound -- sequence )
'[1,b] [
  1 swap [a,b]
] def
