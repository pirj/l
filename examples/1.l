= no functions, straight execution
7 dup * puts

= define a function named "square-of-double"
'square-of-double [ 2 * dup * ] def

5 square-of-double puts
= outputs 100

= stack shuffling
1 2 3 2drop puts
= outputs 1, since 2 and 3 are dropped

'false puts
false puts
= outputs 'false twice

= evaluates a quote
= same as
=   1 puts
[ 1 puts ] call
= outputs 1

= basic arithmetic

5 3 -  = 2
4 *    = 8
2 +    = 10
5 /    = 2
puts
= outputs 2

= equality comparison
'false 'false is puts       = 'true
'false 'ubiquitous is puts  = 'false
'true not puts              = 'false

= conditionals
false [ 1 puts ] when       = outputs nothing
'truthy [ 33 puts ] when    = outputs 33

= preserving combinators
1 2 3 '+ dip puts puts
= outputs 3 3

1 1 3 5 '+ 2dip puts puts puts
= outputs 5 3 2

1 2 over puts puts puts
= outputs 1 2 1

2 3 4 2over puts puts puts puts puts
= outputs 3 2 4 3 2
