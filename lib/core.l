== Program

= builtin 'use ( filenames -- )
= builtin 'load ( filenames -- )
= builtin 'eval ( string -- )
= builtin 'fail ( -- )

== Logic

= false returns itself
'false [ 'false ] def

= ( boolean -- inverse )
'not [ 'false is ] def

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

= builtin 'is ( value value -- boolean )

= builtin 'curry ( expression quote -- curried-quote )

= builtin 'quote ( expression -- quote )

= ( quote quote -- composed )
'compose [
  [ call ] curry
  [ [ call ] curry ] dip
  [ 'call dip call ] curry curry
] def

== Shuffle words

= builtin 'dup ( x -- x x )

= builtin 'drop ( x -- )

= builtin 'swap ( x y -- y x )

= ( x y -- x y x y )
'2dup [ over over ] def

= ( x y z -- x y z x y z )
'3dup [ pick pick pick ] def

= ( x y -- y )
'nip [ 'drop dip ] def

= ( x y -- x y x )
'over [ 'dup dip swap ] def

= ( x y z -- x y z x )
'pick [ 'dup 2dip 'swap dip swap ] def

= ( a b c d -- c d a b )
'2swap [ 'swap dip  = a c b d
  'swap 2dip        = c a b d
  swap              = c a d b
  'swap dip         = a b c d
] def

= ( x y -- )
'2drop [ drop drop ] def


== Preserving combinators

= builtin 'dip ( x quote -- x )

= ( x y quote -- x y )
'2dip [ [ dip ] curry dip ] def
