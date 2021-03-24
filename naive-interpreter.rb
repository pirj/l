class Parser
  def initialize(tokens)
    @tokens = tokens
  end

  private

  attr_reader :tokens
end

class AST < Parser
  def initialize(tokens)
    super
    @expressions = []
  end

  def parse
    while tokens.any?
      expression = next_expression
      expressions << expression if expression
    end

    expressions
  end

  private

  attr_reader :expressions

  def next_expression
    case tokens.first
      when /^\=/ # begin of comment
        Comment.new(tokens).parse
      when '[' # begin of quote
        QuoteParser.new(tokens).parse
      when /^'/ # begin of single-quote
        SingleQuoteParser.new(tokens).parse
      when /^\d+$/ # integer literal
        NumberLiteral.new(tokens).parse
      when /[\w+-\\*\/]+/
        WordParser.new(tokens).parse
      when /\n/
        tokens.shift
        nil
      else
        warn "WTF #{tokens.shift}"
        nil
      end
  end
end

class Comment < Parser
  def parse
    parts = tokens.take_while { |token| token != "\n" }
    parts.count.times { tokens.shift }
    @comment = parts.join(' ')
    self
  end

  def inspect
    "<comment>"
  end

  def run(context)
  end

  private

  attr_reader :comment
end

class NumberLiteral < Parser
  def parse
    @number = Integer(tokens.shift)
    self
  end

  def inspect
    @number.to_s
  end

  def to_s
    inspect
  end

  def run(context)
    context.stack.push(@number)
  end
end

class QuoteParser < AST
  def parse
    tokens.shift # [
    while tokens.any? && (tokens.first != "]")
      expression = next_expression
      expressions << expression if expression
    end
    tokens.shift # ]
    Quote.new(*expressions)
  end
end

class SingleQuoteParser < AST
  def parse
    quoted_word = tokens.shift.slice(1..-1)
    Quote.new(Word.new(quoted_word))
  end
end

class WordParser < Parser
  def parse
    word = tokens.shift
    Word.new(word)
  end
end

class Quote
  def initialize(*expressions)
    @expressions = expressions
  end

  def inspect
    expressions.one? ?
      "'#{expressions.first.inspect}" :
      "[ #{expressions.map(&:inspect).join(' ')} ]"
  end

  def to_s
    inspect
  end

  def run(context)
    context.stack.push(self)
  end

  def call(context)
    context.expressions.unshift(*expressions)
  end

  def eql?(other)
    expressions.eql?(other.expressions)
  end

  def hash
    @__hash = expressions.hash
  end

  attr_accessor :expressions
end

class Word
  def initialize(word)
    @word = word
  end

  def self.quoted(word)
    Quote.new(new(word))
  end

  def run(context)
    quote = context.scope.fetch(Quote.new(self))
    quote.call(context)
  end

  def inspect
    word.to_s
  end

  def hash
    word.hash
  end

  def eql?(other)
    word.eql?(other.word)
  end

  protected

  attr_reader :word
end

class Builtin
  def initialize(&block)
    @implementation = block
  end

  def call(context)
    @implementation.call(context.stack, context.scope, context.expressions)
  end

  def inspect
    "<predefined>"
  end
end

def expressions_from_file(filename)
  source = File.read(filename)

  # lexer: include the freaking newlines (just too hard for me with regex)
  tokens = source.lines(chomp: true).map(&:split).zip(["\n"].cycle).flatten

  # parser
  AST.new(tokens).parse
end

# builtins
def def_builtin(scope, name, &block)
  scope[Word.quoted(name)] = Builtin.new(&block)
end

scope = {}

def_builtin(scope, 'puts') { |stack| puts stack.pop }
def_builtin(scope, 'dup')  { |stack| stack.push(stack.last) }
def_builtin(scope, '+')    { |stack| stack.push(stack.pop + stack.pop) }
def_builtin(scope, '-')    { |stack| x, y = stack.pop(2); stack.push(x - y) }
def_builtin(scope, '*')    { |stack| stack.push(stack.pop * stack.pop) }
def_builtin(scope, '/')    { |stack| x, y = stack.pop(2); stack.push(x / y) }
def_builtin(scope, 'def')  { |stack, scope| quote = stack.pop; quoted_word = stack.pop; scope[quoted_word] = quote }
def_builtin(scope, 'drop') { |stack| stack.pop }
def_builtin(scope, 'over') { |stack| a, b = stack.pop(2); stack.push(a, b, a) }
def_builtin(scope, 'pick') { |stack| a, b, c = stack.pop(3); stack.push(a, b, c, a) }
def_builtin(scope, 'swap') { |stack| a, b = stack.pop(2); stack.push(b, a) }
def_builtin(scope, 'call') { |stack, _, expressions| quote = stack.pop; expressions.unshift(*quote.expressions) }
def_builtin(scope, 'tail-head') do |stack, _scope|
  quote = stack.pop
  raise 'Sequence has to be composed of two parts, head and tail' unless quote.expressions.length == 2
  head, tail = quote.expressions
  stack.push(tail, head)
end
FALSE = Word.quoted('false')
TRUE = Word.quoted('true')
def_builtin(scope, 'is')   { |stack| stack.push(stack.pop.eql?(stack.pop) ? TRUE : FALSE) }
def_builtin(scope, 'not')  { |stack| stack.push(stack.pop.eql?(FALSE) ? TRUE : FALSE) }
def_builtin(scope, 'when') { |stack, _, expressions| condition, quote = stack.pop(2); expressions.unshift(*quote.expressions) unless condition.eql?(FALSE) }
def_builtin(scope, 'curry') { |stack| expression, quote = stack.pop(2); stack.push(Quote.new(expression, *quote.expressions)) }

core_expressions = expressions_from_file('lib/core.l')
program_expressions = expressions_from_file(ARGV.first)
expressions = [*core_expressions, *program_expressions]

require 'ostruct'
context = OpenStruct.new(stack: [], scope: scope, expressions: expressions)

while expressions.any?
  expression = expressions.shift
  warn "-- <#{expression.inspect}> #{expressions.map(&:inspect).join(' ')}" if ENV['DEBUG']
  warn " -: #{context.stack.join(' ')}\n\n" if ENV['DEBUG']
  expression.run(context)
end

warn "Program left with a non-empty stack: #{context.stack}" unless context.stack.empty?
