= false returns itself
'false [ 'false ] def

= builtin 'mul ( x y -- product )

= builtin 'def ( name implementation -- )

= builtin 'puts ( x -- )


== Shuffle words

= builtin 'dup ( x -- x x )

= builtin 'drop ( x -- )

= ( x y -- )
'2drop [ drop drop ] def
