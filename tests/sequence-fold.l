'sequence use

'sum [ 0 '+ fold ] def
4 [1,b] 0 '+ fold 10 assert-is

'product [ '* reduce ] def

4 [1,b] product 24 assert-is
