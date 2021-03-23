= false returns itself
'false [ 'false ] def

= builtin 'mul ( x y -- product )

= builtin 'def ( name implementation -- )

= builtin 'puts ( x -- )

= builtin 'call ( quote -- )


== Shuffle words

= builtin 'dup ( x -- x x )

= builtin 'pick ( x y z -- x y z x )

= builtin 'drop ( x -- )

= builtin 'swap ( x y -- y x )

= ( x y -- )
'2drop [ drop drop ] def


== Sequence combinators

= builtin 'tail-head ( sequence -- sequence-or-false value )
