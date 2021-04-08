'test use

= preserving combinators

1 3 5 '+ dip  = 4 5
  5 assert-is
  4 assert-is

1 1 3 5 '+ 2dip  = 2 3 5
  5 assert-is
  3 assert-is
  2 assert-is

1 3 5 [ + + ] keep  = 9 5
  5 assert-is
  9 assert-is

1 3 5 [ + + ] 2keep = 9 3 5
  5 assert-is
  3 assert-is
  9 assert-is

2 [ 1 - ] [ 1 + ] bi  = 1 3
  3 assert-is
  1 assert-is

3 2 [ - ] [ + ] 2bi  = 1 5
  5 assert-is
  1 assert-is
