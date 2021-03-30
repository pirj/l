== Program

= builting 'use ( filenames -- )

= builting 'load ( filenames -- )

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

= ( quote times -- )
'times [
  over             = quote times quote
  'call 2dip swap  = quote times
  1 - dup 0 is     = quote times-less last?
  '2drop 'times if
] def


== Functions

= builtin 'def ( name implementation -- )


== Quotes

= builtin 'call ( quote -- )

= builtin 'is ( quote quote -- boolean )

= builtin 'curry ( expression quote -- curried-quote )

= ( expression expression quote -- curried-quote )
'2curry [ curry curry ] def

= ( expression expression expression quote -- curried-quote )
'3curry [ curry curry curry ] def

= builtin 'quote ( expression -- quote )


== Shuffle words

= builtin 'dup ( x -- x x )

= ( x y -- x y x y )
'2dup [ over over ] def

= ( x y z -- x y z x y z )
'3dup [ pick pick pick ] def

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
