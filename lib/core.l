== Logic

= false returns itself
'false [ 'false ] def

= ( condition -- is-false )
'false? [ 'false is ] def

= builtin 'not ( boolean -- inverse )

= builtin 'when ( condition quote -- )


== Sequences

= ( sequence quote -- )
'each [
  swap       = quote sequence
  tail-head  = quote sequence value
  pick       = quote sequence value quote
  call       = quote sequence
  swap       = sequence quote
  [ each ]   = sequence quote [ each ]
  curry      = sequence [ quote each ]
  over       = sequence [ quote each ] sequence
  swap       = sequence sequence [ quote each ]
  when       = sequence quote each / 'false
  drop       = --
] def

= build a range sequence
'[1,b] [  = ( bound -- sequence )
  [ false ] [1,b]i
] def

'[1,b]i [  = internal ( index sequence -- prev-index sequence )

= rework to use dip?
  swap      = seq index
  1 -       = seq prev-index
  swap      = prev-index seq

  quote

  2dup      = prev-index seq prev-index seq
  drop      = prev-index seq prev-index
  swap      = prev-index prev-index seq
  curry     = prev-index new-seq
  over      = prev-index new-seq prev-index
  1 is not  = prev-index new-seq last-iteration?
  '[1,b]i   = prev-index new-seq last-iteration? <recursive-call>
  when
  nip
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

= ( x y -- )
'2drop [ drop drop ] def


== Preserving combinators

= builtin 'dip ( x quote -- x )

= builtin '2dip ( x y quote -- x y )


== Sequence combinators

= builtin 'tail-head ( sequence -- sequence-or-false value )
