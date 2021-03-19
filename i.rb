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
      when /\w+/
        ast << Word.new(tokens).parse
      when /\n/
      else
        p "WTF #{tokens.shift}"
      end
  end

  class Comment
    def initialize(tokens)
      @tokens = tokens
    end

    attr_reader :tokens, :comment

    def parse
      parts = tokens.take_while { |token| token != "\n" }
      tokens.drop(parts.count)
      @comment = parts.join(' ')
      self
    end

    def inspect
      "<comment: #{@comment}>"
    end
  end

  class Quote
    def initialize(tokens)
      @tokens = tokens
      @parts = []
    end

    attr_reader :parts

    def parse
      self.parts = tokens.take_while { |token| token != "\n" }
      tokens.drop(parts.count)
      self
    end

    def inspect
      "[ #{parts} ]"
    end
  end

  class Word
    def initialize(tokens)
      @tokens = tokens
    end

    def parse
      @word = tokens.shift
      self
    end

    def inspect
      "#{@word}"
    end
  end
end

# include the freaking newlines: just too hard for me with regex
tokens = source.lines(chomp: true).map(&:split).zip(["\n"].cycle).flatten

p tokens

p AST.parse(tokens)
