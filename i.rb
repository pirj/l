source = File.read(ARGV.first)

class AST
  def self.parse(tokens)
    new(tokens).parse
  end

  def initialize(tokens)
    @tokens = tokens
    @ast = []
  end

  def parse
    while tokens.any?
      token
    end

    ast
  end

  private

  attr_reader :tokens
  attr_reader :ast

  def token
    case tokens.first
      when '.' # begin of comment
        ast << Comment.new(tokens).parse
      when '[' # begin of quotation
        ast << Quote.new(tokens).parse
      when /\d+/ # integer literal
        ast << NumberLiteral.new(tokens).parse
      when /[\w-]+/
        ast << Word.new(tokens).parse
      when /\n/
        tokens.shift
      else
        p "WTF #{tokens.shift}"
      end
  end

  class Element
    def initialize(tokens)
      @tokens = tokens
    end

    private

    attr_reader :tokens
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
  end

  class Quote < Element
    def parse
      tokens.shift
      self.parts = tokens.take_while { |token| token != "]" }
      tokens.shift
      parts.count.times { tokens.shift }
      self
    end

    def inspect
      "<quote: [ #{parts.join(' ')} ]>"
    end

    private

    attr_accessor :parts
  end

  class Word < Element
    def parse
      @word = tokens.shift
      self
    end

    def inspect
      @word.to_s
    end
  end
end

# include the freaking newlines: just too hard for me with regex
tokens = source.lines(chomp: true).map(&:split).zip(["\n"].cycle).flatten

p AST.parse(tokens)
