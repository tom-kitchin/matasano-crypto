require 'enumerator'

class Plaintext
  ENGLISH_LETTER_FREQUENCY_SCORE_LOOKUP = Hash[[*('zqxjkvbpygfwmucldrhsnioate'.split(//)).map.with_index]]

  def initialize(text)
    @text = text#.encode(
    #   Encoding.find('US-ASCII'),
    #   {
    #     invalid: :replace,
    #     undef: :replace,
    #     replace: ''
    #   }
    # )
  end

  def to_s
    @text.gsub(/[^0-9A-Za-z]/, '_')
  end

  def score
    total = score_by_english_letter_frequency
    total
  end

  def score_by_english_letter_frequency
    @text.downcase.split(//).reduce(0) do |acc, char|
      acc + ENGLISH_LETTER_FREQUENCY_SCORE_LOOKUP.fetch(char, 0)
    end
  end
end

class PlaintextCollection
  include Enumerable

  def initialize
    @collection = []
  end

  def best
    @collection.max { |a, b| a.score <=> b.score }
  end

  def push(plaintext)
    plaintext = Plaintext.new(plaintext) if plaintext.is_a? String
    unless plaintext.is_a?(Plaintext)
      fail ArgumentError, 'Not a Plaintext object'
    end
    @collection.push(plaintext)
  end

  def each
    @collection.each { |i| yield i }
  end
end
