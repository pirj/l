= no functions, straight execution
7 dup mul puts

= define a function named "square-of-double"
'square-of-double [ 2 mul dup mul ] def

5 square-of-double puts
= outputs 100

= stack shuffling
1 2 3 2drop puts
= outputs 1, since 2 and 3 are dropped
