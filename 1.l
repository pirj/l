. skipping:
. - simplified form for quotations 'sq
. - stack effects ( number -- square )
. - optional whitespace [sq], [dup *], (number -- square)

. no functions
7 dup mul puts

. word-only functions
[ sq ] [ dup mul ] def
5 sq puts

. with literals - required recursive parsing
[ double ] [ 2 mul ] def
10 double puts
