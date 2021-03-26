== Logic

= false returns itself
'false [ 'false ] def

= ( condition -- is-false )
'false? [ 'false is ] def

= builtin 'not ( boolean -- inverse )

= builtin 'when ( condition quote -- )

= ( boolean true-quote false-quote -- )
'if [
  pick not swap  = boolean true-quote negated false-quote
  '2dip curry    = boolean true-quote negated [ false-quote 2dip ]
  when
  when
] def

== Sequences

= ( sequence quote -- )
'each [
  'tail-head
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


== Basic arithmetic

= builtin '+ ( x y -- sum )

= builtin '- ( x y -- difference )

= builtin '* ( x y -- product )

= builtin '/ ( x y -- quotient )


== Functions

= builtin 'def ( name implementation -- )


== Quotes

= builtin 'call ( quote -- )

= builtin 'is ( quote quote -- boolean )

= builtin 'curry ( expression quote -- quote )

= builtin 'quote ( expression -- quote )


== Input/output

= builtin 'puts ( x -- )


== Shuffle words

= builtin 'dup ( x -- x x )

= builtin '2dup ( x y -- x y x y )

= builtin 'nip ( x y -- y )

= builtin '2nip ( x y z -- z )

= builtin 'over ( x y -- x y x )

= builtin '2over ( x y z -- x y z x y)

= builtin 'pick ( x y z -- x y z x )

= builtin 'drop ( x -- )

= builtin 'swap ( x y -- y x )

= builtin '2swap ( a b c d -- c d a b )

= ( x y -- )
'2drop [ drop drop ] def


== Preserving combinators

= builtin 'dip ( x quote -- x )

= builtin '2dip ( x y quote -- x y )


== Sequence combinators

= builtin 'tail-head ( sequence -- sequence-or-false value )


== Debug

= builtin 'debug ( -- )

= builtin 'fail ( -- )
