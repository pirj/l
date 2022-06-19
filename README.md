# L programming language

Welcome to L

## What is L?

L is a new programming language. It is:
 - simple, easy to read (when you dig it)
 - concise, easy to type

## Inspiration Sources

[Factor](https://factorcode.org/), [Forth](https://en.wikipedia.org/wiki/Forth_(programming_language)), [Lisp](https://en.wikipedia.org/wiki/Lisp_(programming_language)), [Clojure](https://clojure.org/about/rationale), [Erlang](https://rvirding.blogspot.com/2019/01/the-erlang-rationale.html), [Python](https://en.m.wikipedia.org/wiki/Zen_of_Python), Paul Graham's work on [Arc](http://www.paulgraham.com/lisp.html), partially by [Ruby](https://www.ruby-lang.org/) and [Crystal](https://crystal-lang.org/), and lately [RetroForth](http://retroforth.org) and [Koka](https://koka-lang.github.io/koka).

> One reason Lisp cores evolve so slowly is that we get used to them. You start to think in the operators that already exist. It takes a conscious effort to imagine how your code might be rewritten using operators that don't. -- Paul Graham

> Making things easy to do is a false economy. Focus on making things easy to understand and the rest will follow. -- Peter Bourgon

## Sneak Peek

Straight to the code!

```
5 puts
```

Feels a bit backwards? It is, but it is always the way the computer runs it anyway.
When you'll get used to it, you will never have to think what evaluates first again:

Ruby:
```ruby
puts File.read(gets.chomp)
```
in that order: `gets` -> `chomp` -> `File.read` -> `puts`

L:
```
gets chomp file:read puts
```

## Building Blocks

Word, a named function:
```
recent-emails
```

Literal:
```
1
'hello'
6.626
```

Quote, an anonymous function, a value denoting a snippet of code:
```
[ 3 + ]
```

One-word quote, can be used as a unique value:
```
'album
```

or as a singleton if a correspondingly named function exists:
```
'false
```
it is equal to itself only.

### Reuse

Functions and methods most probably sound familiar to you. L is not exception to that.

Quotes can be associated with a word.
First comes quoted word that serves as a function handle, then the quote the function implementation, and a `def` to associate the two:
```
'multiply-by-two [ 2 * ] def
```

It can be used right away, pass it a `5` as input, tell it to print the result, and, to no surprise, this prints `10`:
```
5 multiply-by-two puts
```
This, to no surprise, prints `10`.

## Running

Install Ruby.

Run the test suite:
```
ruby naive-interpreter.rb tests/all.l
```

Run REPL:
```
ruby naive-interpreter.rb repl.l
```

## Learn

No learning resources for a language that young exist (~it's just one day old!~).
Articles about concatenative languages should get you going:

https://github.com/andreaferretti/factor-tutorial
https://evincarofautumn.blogspot.com/2012/02/why-concatenative-programming-matters.html

## Status

Work in progress. The current lexer/parser/interpreter are written in Ruby.

Short-term plans:
 - [x] parsing of simplified form for single-word quotes `'square`
 - [ ] add error traces
 - [ ] bootstrap so L can interpret itself
 - [ ] settle on a set of base functions

## Design Decisions

Concatenative, Reverse Polish Notation (vs parenthesis).

Homoiconicity, code is data.

Names and special characters:
 - hyphen vs underscore in names (`paint-green`)
 - lower-case (`president-of-united-world`)
 - single-quote (`'hello, united world!'`, `divide 'conquer each`)
 - equals sign for comments (`1 puts  = this outputs '1' to the standard output`)
 - square brackets (`[ spare-your-pinkies ]`)
 - question mark for words with a boolean result (`pick-apple yellow? 'eat if`)

No special syntax if possible, e.g. no symbols (a one-word quote is identical to itself).

Parsing words vs compile-time inlining. Due to homoiconicity, it is impossible to tell if a quote will be evaluated or used as a data structure:
```
[ 1 1 + ] call  = 2
= vs
[ 1 1 + ] [ 1 ] compose = [ 1 1 + 1 ]
```

A parsing word would run during parsing, and can specify inlining and any other code transformation before execution.
```
'two [ 1 1 + ] \inline def
= transformed to just:
'two [ 2 ] def

= or
'red [ f00 \rgb ] def
= transformed to:
'red [ '#FF0000' ] def
```

## License

Copyright 2021 Phil Pirozhkov

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this software except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the License for the specific language governing permissions and limitations under the License.
