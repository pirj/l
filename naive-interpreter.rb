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
      when '[' # begin of quote
        QuoteParser.new(tokens).parse
      when /^'/ # begin of single-quote
       SingleQuoteParser.new(tokens).parse
      when /^"/ # begin of single-quote
       StringLiteral.new(tokens.shift[1..-1])
      when /^\d+$/ # integer literal
        NumberParser.new(tokens).parse
      when /^[\w+-\\*\/\[\],]+$/
        WordParser.new(tokens).parse
      when ''
        tokens.shift
        nil
      else
        warn "WTF #{tokens.shift}"
        nil
      end
  end
end

class StringLiteral
  def initialize(string)
    @string = string.freeze
  end

  def inspect
    string
  end

  def to_s
    inspect
  end

  def run(stack, *)
    stack.push(self)
  end

  def eql?(other)
    string.eql?(other.string)
  end

  protected

  attr_reader :string
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
    other.is_a?(NumberLiteral) && number.eql?(other.number)
  end

  def expressions
    [self]
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
    exprs.one? && exprs.first.is_a?(Word) ?
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
    other.is_a?(Quote) && exprs.eql?(other.exprs)
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

module Lexer
  class << self
    def lex(source)
      tokens = []
      rest = source
      while !rest.empty?
        token, separator, rest = rest.partition(/\s*[=]+\s*|"|\s+/)

        case separator.strip
        when /^=/
          tokens << token
          _, _, rest = rest.partition(/\n+\s*/) # skip until EOL
        when /^"/
          token, _, rest = rest.partition(/"/) # take until closing "
          tokens << "\"#{token}"
        else
          tokens << token
        end
      end
      tokens
    end
  end
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
    @dir_stack = []
    @base_stack = []
  end

  def load(filename)
    @dir_stack.push(File.dirname(filename))
    stack = Stack.new

    source = File.read(filename)
    evaluate(source, stack)

    warn "#{filename} left with a non-empty stack: #{stack}" unless stack.empty?
    @dir_stack.pop
  end

  def evaluate(source, stack = @base_stack)
    expressions = expressions(source)

    while expressions.any?
      expression = expressions.shift
      warn "-- <#{expression.inspect}> #{expressions.map(&:inspect).join(' ')}" if ENV['DEBUG']
      warn " -: #{stack.join(' ')}\n\n" if ENV['DEBUG']
      expression.run(stack, @scope, expressions)
    end
  end

  def def_builtin(name, &block)
    @scope[Word.quoted(name)] = Builtin.new(&block)
  end

  def pwd
    @dir_stack.last
  end

  private

  def expressions(source)
    tokens = Lexer.lex(source)
    AST.new(tokens).parse
  end
end

runner = Runner.new

runner.def_builtin('puts') { |stack| STDOUT.puts stack.pop }
runner.def_builtin('print') { |stack| STDOUT.print stack.pop }
runner.def_builtin('gets') { |stack| stack.push(STDIN.gets) }

runner.def_builtin('+')    { |stack| stack.push(stack.pop + stack.pop) }
runner.def_builtin('-')    { |stack| x, y = stack.pop(2); stack.push(x - y) }
runner.def_builtin('*')    { |stack| stack.push(stack.pop * stack.pop) }
runner.def_builtin('/')    { |stack| x, y = stack.pop(2); stack.push(x / y) }

runner.def_builtin('def')  { |stack, scope| quote = stack.pop; quoted_word = stack.pop; scope[quoted_word] = quote }
runner.def_builtin('call') { |stack, _, expressions| quote = stack.pop; expressions.unshift(*quote.expressions) }

runner.def_builtin('dup')  { |stack| stack.push(stack.last) }
runner.def_builtin('drop') { |stack| stack.pop }
runner.def_builtin('swap') { |stack| a, b = stack.pop(2); stack.push(b, a) }

runner.def_builtin('curry') { |stack| expression, quote = stack.pop(2); stack.push(Quote.new(expression, *quote.expressions)) }
runner.def_builtin('quote') { |stack| expression = stack.pop; stack.push(Quote.new(expression)) }

FALSE = Word.quoted('false')
TRUE = Word.quoted('true')
runner.def_builtin('is')   { |stack| stack.push(stack.pop.eql?(stack.pop) ? TRUE : FALSE) }
runner.def_builtin('when') { |stack, _, expressions| condition, quote = stack.pop(2); expressions.unshift(*quote.expressions) unless condition.eql?(FALSE) }

runner.def_builtin('dip')  { |stack, _, expressions| x, quote = stack.pop(2); stack.push(quote); expressions.unshift(Word.new('call'), x) }

runner.def_builtin('stack') { |stack| puts stack }
runner.def_builtin('fail') { |stack| failure_message = stack.pop; fail failure_message.to_s }

runner.def_builtin('use') { |stack| stack.pop.expressions.each { |filename| runner.load("lib/#{filename}.l") } }
runner.def_builtin('load') { |stack| stack.pop.expressions.each { |filename| runner.load("#{runner.pwd}/#{filename}.l") } }
runner.def_builtin('eval') { |stack| runner.evaluate(stack.pop) }

runner.load('lib/core.l')
runner.load(ARGV.first)
