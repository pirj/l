== Logic

= false returns itself
'false [ 'false ] def

= ( condition -- is-false )
'false? [ 'false is ] def

= builtin 'not ( boolean -- inverse )

= builtin 'when ( condition quote -- )

= TODO: rewrite with nip/keep
= TODO: drop final 'false from stack
= ( quote -- )
'each [
  swap tail-head pick call swap [ each ] curry over swap when
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

= ( x quote ( x -- ) -- x )
'keep [ over swap call ] def


== Input/output

= builtin 'puts ( x -- )


== Shuffle words

= builtin 'dup ( x -- x x )

= builtin '2dup ( x y -- x y x y )

= builtin 'nip ( x y -- y )

= builtin '2nip ( x y z -- z )

= builtin 'over ( x y -- x y x )

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
