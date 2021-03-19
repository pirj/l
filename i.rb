source = File.read(ARGV.first)

class Element
  def initialize(tokens)
    @tokens = tokens
  end

  private

  attr_reader :tokens
end

class AST < Element
  def initialize(tokens)
    super
    @expressions = []
  end

  def parse
    while tokens.any?
      token
    end

    expressions
  end

  private

  attr_reader :expressions

  def token
    case tokens.first
      when '.' # begin of comment
        expressions << Comment.new(tokens).parse
      when '[' # begin of quotation
        expressions << QuoteParser.new(tokens).parse
      when /\d+/ # integer literal
        expressions << NumberLiteral.new(tokens).parse
      when /[\w-]+/
        expressions << Word.new(tokens).parse
      when /\n/
        tokens.shift
      else
        p "WTF #{tokens.shift}"
      end
  end
end

class Comment < Element
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

class NumberLiteral < Element
  def parse
    @number = Integer(tokens.shift)
    self
  end

  def inspect
    "<number: #{@number}>"
  end

  def run(context)
    context.stack.push(@number)
  end
end

class QuoteParser < AST
  def parse
    tokens.shift # [
    while tokens.any? && (tokens.first != "]")
      token
    end
    tokens.shift # ]
    Quote.new(*expressions)
  end
end

class Quote
  def initialize(*expressions)
    @expressions = expressions
  end

  attr_accessor :expressions

  def inspect
    expressions.one? ?
      "'#{expressions.first}" :
      "[ #{expressions.map(&:inspect).join(' ')} ]"
  end

  def run(context)
    context.stack.push(self)
  end

  def call(context)
    expressions.each do |expression|
      expression.run(context)
    end
  end

  def ==(other)
    expressions.count == other.expressions.count &&
      expressions.each_with_index.all? { |part, index| part == other.expressions[index] }
  end

  def hash
    @__hash = expressions.hash
  end
end

class Word < Element
  def parse
    @word = tokens.shift
    self
  end

  # yuck
  attr_reader :word

  def run(context)
    quote = context.scope.fetch(@word)
    quote.call(context)
  end

  def inspect
    @word.to_s
  end
end

class Builtin
  def initialize(&block)
    @implementation = block
  end

  def call(context)
    @implementation.call(context.stack, context.scope)
  end

  def inspect
    "<predefined>"
  end
end

# lexer: include the freaking newlines (just too hard for me with regex)
tokens = source.lines(chomp: true).map(&:split).zip(["\n"].cycle).flatten

# parser
ast = AST.new(tokens).parse

# interpreter, for now just
#   puts
#   dup
#   mul
#   def
scope = {
  'puts' => Builtin.new { |stack, _scope| puts stack.pop },
  'dup'  => Builtin.new { |stack, _scope| stack.push(stack.last) },
  'mul'  => Builtin.new { |stack, _scope| stack.push(stack.pop * stack.pop) },
  'def'  => Builtin.new { |stack, scope|  quote = stack.pop; unquoted_word = stack.pop.expressions.first.word; scope[unquoted_word] = quote }
}
require 'ostruct'
context = OpenStruct.new(stack: [], scope: scope)
ast.each do |expression|
  expression.run(context)
  # puts({e: expression, c: context})
end
