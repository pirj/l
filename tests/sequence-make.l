[ sequence test ] use

'sum [ 0 '+ fold ] def

'1,3 [
  [ 1 [ dup 1 + dup 3 is ] next-until ]
] def

1,3 sum 6 assert-is

'1,4 [ 1 [ 1 + ] [ 4 is ] make-sequence ] def

1,4 sum 10 assert-is

'1,5 [ 5 [1,b] ] def

1,5 sum 15 assert-is

'2,6 [ 2 6 [a,b] ] def
2,6 sum 20 assert-is

'infinite [ [ drop false ] ] def

'linear [
  1 [ 1 + ] infinite make-sequence
] def

linear 6 nth 6 assert-is
