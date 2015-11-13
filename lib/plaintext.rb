require 'enumerator'

class Plaintext
  attr_reader :text, :key

  # Note that spaces are given a medium value.
  ENGLISH_LETTER_FREQUENCY_SCORE_LOOKUP = Hash[[*('zqxjkvbpygfw mucldrhsnioate'.split(//)).map.with_index]]

  def initialize(text, key = nil)
    @text = text
    @key = key
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
      acc + ENGLISH_LETTER_FREQUENCY_SCORE_LOOKUP.fetch(char, 0)
    end
  end
end

class PlaintextCollection
  include Enumerable

  def initialize(collection = nil)
    if collection
      collection.map { |item| push(item) }
    else
      @collection = []
    end
  end

  def best
    @collection.max { |a, b| a.score <=> b.score }
  end

  def push(plaintext, key = nil)
    plaintext = Plaintext.new(plaintext, key) if plaintext.is_a? String
    unless plaintext.is_a?(Plaintext)
      fail ArgumentError, 'Not a Plaintext object'
    end
    @collection.push(plaintext)
  end

  def each
    @collection.each { |i| yield i }
  end
end
