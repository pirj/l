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
        Comment.new(tokens).parse # skip
        next_expression
      when '[' # begin of quote
        QuoteParser.new(tokens).parse
      when /^'/ # begin of single-quote
        SingleQuoteParser.new(tokens).parse
      when /^\d+$/ # integer literal
        NumberParser.new(tokens).parse
      when /^[\w+-\\*\/\[\],]+$/
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
end

class NumberParser < Parser
  def parse
    NumberLiteral.new(tokens.shift)
  end
end

class NumberLiteral
  def initialize(number)
    @number = Integer(number)
  end

  def inspect
    number.to_s
  end

  def to_s
    inspect
  end

  def run(stack, *)
    stack.push(self)
  end

  def +(other)
    NumberLiteral.new(number + other.number)
  end

  def -(other)
    NumberLiteral.new(number - other.number)
  end

  def *(other)
    NumberLiteral.new(number * other.number)
  end

  def /(other)
    NumberLiteral.new(number / other.number)
  end

  def eql?(other)
    number.eql?(other.number)
  end

  protected

  attr_reader :number
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
    @exprs = expressions
  end

  def inspect
    exprs.one? ?
      "'#{exprs.first.inspect}" :
      "[ #{exprs.map(&:inspect).join(' ')} ]"
  end

  def to_s
    inspect
  end

  def run(stack, *)
    stack.push(self)
  end

  def call(_stack, _scope, expressions)
    expressions.unshift(*exprs)
  end

  def eql?(other)
    exprs.eql?(other.exprs)
  end

  def hash
    @__hash = exprs.hash
  end

  def two?
    exprs.length == 2
  end

  # Prevent modification
  def expressions
    exprs.each
  end

  protected

  attr_accessor :exprs
end

class Word
  def initialize(word)
    @word = word
  end

  def self.quoted(word)
    Quote.new(new(word))
  end

  def run(stack, scope, expressions)
    quote = scope.fetch(Quote.new(self))
    quote.call(stack, scope, expressions)
  end

  def inspect
    word.to_s
  end

  def to_s
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

  def call(stack, scope, expressions)
    @implementation.call(stack, scope, expressions)
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

class Stack < Array
  def pop(*args)
    items = args.any? ? args.first : 1
    raise 'Stack underflow' if length < items
    super
  end
end

class Runner
  def initialize
    @scope = {}
  end

  def run(filename)
    stack = Stack.new

    expressions = expressions_from_file(filename)

    while expressions.any?
      expression = expressions.shift
      warn "-- <#{expression.inspect}> #{expressions.map(&:inspect).join(' ')}" if ENV['DEBUG']
      warn " -: #{stack.join(' ')}\n\n" if ENV['DEBUG']
      expression.run(stack, @scope, expressions)
    end

    warn "#{filename} left with a non-empty stack: #{stack}" unless stack.empty?
  end

  def def_builtin(name, &block)
    @scope[Word.quoted(name)] = Builtin.new(&block)
  end
end

runner = Runner.new

runner.def_builtin('puts') { |stack| puts stack.pop }

runner.def_builtin('+')    { |stack| stack.push(stack.pop + stack.pop) }
runner.def_builtin('-')    { |stack| x, y = stack.pop(2); stack.push(x - y) }
runner.def_builtin('*')    { |stack| stack.push(stack.pop * stack.pop) }
runner.def_builtin('/')    { |stack| x, y = stack.pop(2); stack.push(x / y) }

runner.def_builtin('def')  { |stack, scope| quote = stack.pop; quoted_word = stack.pop; scope[quoted_word] = quote }
runner.def_builtin('call') { |stack, _, expressions| quote = stack.pop; expressions.unshift(*quote.expressions) }

runner.def_builtin('dup')  { |stack| stack.push(stack.last) }
runner.def_builtin('nip')  { |stack| stack.push(stack.pop(2).last) }
runner.def_builtin('2nip') { |stack| stack.push(stack.pop(3).last) }
runner.def_builtin('drop') { |stack| stack.pop }
runner.def_builtin('over') { |stack| a, b = stack.pop(2); stack.push(a, b, a) }
runner.def_builtin('2over') { |stack| a, b, c = stack.pop(3); stack.push(a, b, c, a, b) }
runner.def_builtin('pick') { |stack| a, b, c = stack.pop(3); stack.push(a, b, c, a) }
runner.def_builtin('swap') { |stack| a, b = stack.pop(2); stack.push(b, a) }
runner.def_builtin('2swap') { |stack| a, b, c, d = stack.pop(4); stack.push(c, d, a, b) }

runner.def_builtin('curry') { |stack| expression, quote = stack.pop(2); stack.push(Quote.new(expression, *quote.expressions)) }
runner.def_builtin('quote') { |stack| expression = stack.pop; stack.push(Quote.new(expression)) }

FALSE = Word.quoted('false')
TRUE = Word.quoted('true')
runner.def_builtin('is')   { |stack| stack.push(stack.pop.eql?(stack.pop) ? TRUE : FALSE) }
runner.def_builtin('not')  { |stack| stack.push(stack.pop.eql?(FALSE) ? TRUE : FALSE) }
runner.def_builtin('when') { |stack, _, expressions| condition, quote = stack.pop(2); expressions.unshift(*quote.expressions) unless condition.eql?(FALSE) }

runner.def_builtin('dip')  { |stack, _, expressions| x, quote = stack.pop(2); stack.push(quote); expressions.unshift(Word.new('call'), x) }
runner.def_builtin('2dip') { |stack, _, expressions| x, y, quote = stack.pop(3); stack.push(quote); expressions.unshift(Word.new('call'), x, y) }

runner.def_builtin('debug') { |stack, scope, expressions| require 'pry'; binding.pry }
runner.def_builtin('fail') { fail }

runner.def_builtin('use') { |stack| stack.pop.expressions.each { |filename| runner.run("lib/#{filename}.l") } }

runner.run('lib/core.l')
runner.run(ARGV.first)
