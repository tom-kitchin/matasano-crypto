require 'crypto_utils'
require 'single_character_xor_decryptor'
require 'repeating_key_xor'

class RepeatingKeyXorDecryptor
  attr_reader :input_bytes, :hamming_distances, :keys, :outputs

  def initialize(input, input_format)
    @input = input
    case input_format
    when :hex
      @input_bytes = @input.as_hex_to_bytes
    when :bytes
      @input_bytes = @input
    when :base64
      @input_bytes = @input.from_base64.bytes
    when :string
      @input_bytes = @input.bytes
    end
  end

  def decrypt
    @hamming_distances = seek_keysize
    solution_pile = @hamming_distances.map { |keysize, _| solve_with_keysize(keysize) }
    results = PlaintextCollection.new
    solution_pile.each { |ptc| ptc.each { |pt| results.push(pt) } }
    results
  end

  def seek_keysize
    possible_keysizes = (2...[@input_bytes.length / 4, 40].min)
    hamming_distances = possible_keysizes.map do |keysize|
      dists = [
        @input_bytes.slice(0, keysize),
        @input_bytes.slice(keysize, keysize),
        @input_bytes.slice(keysize * 2, keysize),
        @input_bytes.slice(keysize * 3, keysize)
      ].combination(2).map { |b1, b2| b1.hamming_distance_to(b2) / keysize.to_f }
      [keysize, dists.reduce(:+) / dists.size.to_f]
    end
    hamming_distances = hamming_distances.sort_by { |_, distance| distance }.reverse.map(&:first)
    hamming_distances.slice(0, 5)
  end

  def solve_with_keysize(keysize)
    possible_keys = collect_possible_keys_for_keysize(keysize)
    ptc = PlaintextCollection.new
    possible_keys.each do |key|
      ptc.push(RepeatingKeyXor.new(key).decrypt_bytes(@input_bytes), key)
    end
    ptc.best_of(3)
  end

  def collect_possible_keys_for_keysize(keysize)
    sets = break_ciphertext_into_blocks(keysize).transpose.map { |block| guess_keys_for_transposed_block(block) }
    head, *tail = *sets
    head.product(*tail).map(&:unbytes)
  end

  def break_ciphertext_into_blocks(keysize)
    @input_bytes.each_slice(keysize).map { |slice| slice.fill(0, slice.length...keysize) }.to_a
  end

  def guess_keys_for_transposed_block(block)
    SingleCharacterXorDecryptor.new(block, :bytes).plaintext.best_of(3).map(&:key)
  end
end
