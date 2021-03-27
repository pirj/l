= code as data

= a specific version of [1,b] and [a,b]
= germ of literal data structures
'[1,3] [
  [ 1 [ 2 [ 3 'false ] ] ]
] def

= a specific version of 'each sequence combinator
= ( sequence quote -- )
'3each [       = oh, inline comments work!
  swap         = ( sequence quote -- quote sequence )

  head-tail swap  = ( sequence -- sequence-or-false value )
  pick         = ( quote sequence-or-false value -- quote sequence-or-false value quote )
  call         = evaluates quote ( quote -- ? )

  head-tail swap  = ( sequence -- sequence-or-false value )
  pick         = ( quote sequence-or-false value -- quote sequence-or-false value quote )
  call         = evaluates quote ( quote -- ? )

  head-tail swap  = ( sequence -- sequence-or-false value )
  pick         = ( quote false value -- quote false value quote )
  call         = evaluates quote ( quote -- ? )

  2drop        = drop the quote and list's 'false tail
] def

[1,3] 'puts 3each
