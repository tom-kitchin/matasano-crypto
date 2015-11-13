require 'crypto_utils'

class RepeatingKeyXorDecryptor
  attr_reader :input, :input_bytes

  def initialize(input, input_format)
    @input = input
    case input_format
    when :hex
      @input_bytes = @input.as_hex_to_bytes
    when :bytes
      @input_bytes = @input.bytes
    when :base64
      @input_bytes = @input.from_base64.bytes
    when :string
      @input_bytes = @input
    end

    hamming_distances = seek_keysize
    puts hamming_distances.inspect
  end

  def seek_keysize
    possible_keysizes = (2...40)
    hamming_distances = {}
    possible_keysizes.each do |keysize|
      block1 = @input_bytes.slice(0, keysize)
      block2 = @input_bytes.slice(keysize, keysize)
      hamming_distance = block1.hamming_distance_to(block2)
      normalised_hamming_distance = hamming_distance / keysize.to_f
      hamming_distances[keysize] = normalised_hamming_distance
    end
    hamming_distances = hamming_distances.sort_by { |_, distance| distance }.reverse
    hamming_distances.slice(0, 3)
  end
end
