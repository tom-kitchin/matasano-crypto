require 'enumerator'

class Plaintext
  attr_reader :text, :key, :source

  # English text frequency
  ENGLISH_LETTER_SCORE = {
    'a' => 0.0651738,
    'b' => 0.0124248,
    'c' => 0.0217339,
    'd' => 0.0349835,
    'e' => 0.1041442,
    'f' => 0.0197881,
    'g' => 0.0158610,
    'h' => 0.0492888,
    'i' => 0.0558094,
    'j' => 0.0009033,
    'k' => 0.0050529,
    'l' => 0.0331490,
    'm' => 0.0202124,
    'n' => 0.0564513,
    'o' => 0.0596302,
    'p' => 0.0137645,
    'q' => 0.0008606,
    'r' => 0.0497563,
    's' => 0.0515760,
    't' => 0.0729357,
    'u' => 0.0225134,
    'v' => 0.0082903,
    'w' => 0.0171272,
    'x' => 0.0013692,
    'y' => 0.0145984,
    'z' => 0.0007836,
    ' ' => 0.1918182
  }

  def initialize(text, key = nil, source = nil)
    @text = text
    @key = key
    @source = source
  end

  def to_s
    @text
  end

  def score
    total = score_by_english_letter_frequency
    total
  end

  def score_by_english_letter_frequency
    @text.downcase.split(//).reduce(0) do |acc, char|
      score = ENGLISH_LETTER_SCORE.fetch(char, 0)
      acc + score
    end
  end
end

class PlaintextCollection
  include Enumerable

  def initialize(collection = nil)
    @collection = []
    collection.map { |item| push(item) } if collection
  end

  def best
    @collection.max { |a, b| a.score <=> b.score }
  end

  def best_of(count)
    PlaintextCollection.new(@collection.sort_by(&:score).reverse.slice(0...count))
  end

  def push(plaintext, key = nil, source = nil)
    plaintext = Plaintext.new(plaintext, key, source) if plaintext.is_a? String
    unless plaintext.is_a?(Plaintext)
      fail ArgumentError, 'Not a Plaintext object'
    end
    @collection.push(plaintext)
  end

  def each
    @collection.each { |i| yield i }
  end
end
