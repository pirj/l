# L programming language

Welcome to L

## What is L?

L is a new programming language. It is:
 - concise (easy to type)
 - simple (easy to read)

## Inspiration Sources

[Factor](https://factorcode.org/), [Forth](https://en.wikipedia.org/wiki/Forth_(programming_language)), [Lisp](https://en.wikipedia.org/wiki/Lisp_(programming_language)), and partially by [Ruby](https://www.ruby-lang.org/) and [Crystal](https://crystal-lang.org/).

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

Word, can refer to a function:
```
recent-emails
```

Literals:
```
1
"hello"
6.626
```

Quote, an anonymous function (a value denoting a snippet of code):
```
[ 3 + ]
```

One-word quote, can be used as a symbol:
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

Define a function named `multiply-by-two`. Followed by a square-bracket delimited anonymous function, or a quote, a code block that represents the implementation. And `def` glue code follows to save the reference to this function in the scope by the name.
```
'multiply-by-two [ 2 mul ] def
```

Let's use it by adding some data, and using the results by outputting them to the console.
```
5 multiply-by-two puts
```
You may expect to see 10 printed.

## Running

Install Ruby.
Run:
```
ruby naive-interpreter.rb examples/1.l
```

## Learn

No learning resources for a language that young exist (it's just one day old!).
Articles about concatenative languages should get you going:

https://github.com/andreaferretti/factor-tutorial
https://evincarofautumn.blogspot.com/2012/02/why-concatenative-programming-matters.html

## Status

Work in progress. The current lexer/parser/interpreter are written in Ruby.

Short-term plans:
 - [ ] parsing of simplified form for single-word quotes `'square`
 - [ ] bootstrap so L can interpret itself
 - [ ] settle on a set of base functions

## Design Decisions

Concatenative, Reverse Polish Notation (vs parenthesis).

Homoiconicity.

Names and special characters (hyphen vs underscore in variable names, lower-case, single-quote, equals sign for comments, square brackets).

No symbols (a quote is identical to itself).

No special syntax.

## License

Copyright 2021 Phil Pirozhkov

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this software except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the License for the specific language governing permissions and limitations under the License.
