== Logic

= false returns itself
'false [ 'false ] def


== Basic arithmetic

= builtin '+ ( x y -- sum )

= builtin '- ( x y -- difference )

= builtin '* ( x y -- product )

= builtin '/ ( x y -- quotient )


== Functions

= builtin 'def ( name implementation -- )


== Quotes

= builtin 'call ( quote -- )


== Input/output

= builtin 'puts ( x -- )


== Shuffle words

= builtin 'dup ( x -- x x )

= builtin 'pick ( x y z -- x y z x )

= builtin 'drop ( x -- )

= builtin 'swap ( x y -- y x )

= ( x y -- )
'2drop [ drop drop ] def


== Sequence combinators

= builtin 'tail-head ( sequence -- sequence-or-false value )
