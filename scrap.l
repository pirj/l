'repl use
'sequence use

= 'linear [
=   [ 1 [ 2 * ] next ]
= ] def
= 
= 'next [  = ( value quote -- value sequence )
=   2dup call     = value quote next-value
=   swap          = value next-value quote
=   'next 'curry 2 times  = value [ next-value quote next ]
= ] def
= 
= linear 5 nth puts

= transforms
=   1 [ * ]
= into
=   1 1 [ 1 + dup [ * ] dip ]
= TODO: extract "dup '* dip" to a quote so it appears nicely in debug?
= TODO: can the same be expressed with 'bi ?
'with-index [  = ( initial quote -- )
  [ 1 [ 1 + dup ] ] dip
  quote compose 'dip compose
] def

= factorial(n) = n * factorial(n-1), 1 1 2 6 24 120 720 5040


= WORKS!
= 1 [ * ] with-index

= stack repl
= !!!!!!!! not. all. sequences. need. previous. value. only most.
= ???????? make-sequence with the default, and without-chaining ?
= !!! non-dependent sequences are easily parallelizable


= a simple example with two indexes, f(n) = n + m (no ref to f(...))
= 111 2 10 [ + nip ] with-index with-index
= 111 [ 12 3 11 ... ]

= EURECA! [ 'call keep ] 3 times  = 3 nth !
= or [ 'call keep nip ] to drop the head ?




= constant sequence that does not depend on either the index or the previous value
= it makes it easy to abstract out the 'next word
= and easy to experiment with stackable modifiers
= it practice, it can be a 'rand, and would allow e.g. to get a *list* of N rands
= even though it's currently possible with
=   rand [ drop rand ] infinite make-sequence
= more concise, and has no boilerplate
=   'rand make-s
= the difference between it and [ rand ] N times is that it's a sequence,
= and not just values on the stack

= ( quote -- sequence )
= turns
=   [ something ]
= to
=   [ first-value-returned-by-something [ something ] next ]
= 'call keep quote 'next compose curry
'next [
  'call keep quote 'next compose curry
] def

= WORKS!
= = evaluates to [ 1 [ 1 ] next ]
= [ 1 ] next

= debug
'n [ call stack ] def

= alias to 'next with an intent-revealing name
'make-s [ 'next curry ] def

[ 1 ] make-s
stack repl

= WORKS!
= = evaluates to [ 1 [ 1 ] next ]
= [ 1 ] make-s

=   1 [ * ]
=   1 1 [ 1 + dup [ * dup ] dip ]
'with-index [  = ( initial quote -- )
  [ 1 [ 1 + dup ] ] dip
  'dup compose
  quote compose 'dip compose
] def

= WORKS!
= TODO
= !!! almost, as it consumes the previous element from the stack while it should keep it
1 [ * ] with-index make-s

stack repl

= doesn't work yet
= double 'curry in 'next may help
= by how to inject that second 'curry there?
= should a modifier do that?
= can a modifier provide additional steps for 'next ?
= 1 1 [ * + ] with-index with-index make-s

= !!! from wikipedia:
= infinite sequences are called streams
= contains members (also called elements, or terms)
= Sequences whose elements are related to the previous elements in a straightforward way are often defined using recursion. This is in contrast to the definition of sequences of elements as functions of their positions

= !!! prime numbers would require
