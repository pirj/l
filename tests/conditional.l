'test use

2 false [ 1 ] when 2 assert-is
'truthy [ 33 ] when 33 assert-is
false [ "oh no" fail ] [ 111 ] if 111 assert-is
'truthy [ 100 ] [ "impossible!" fail ] if 100 assert-is
