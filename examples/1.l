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
