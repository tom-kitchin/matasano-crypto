require 'plaintext'
require 'crypto_utils'

class SingleCharacterXor
  attr_reader :plaintext, :input, :input_bytes

  ORDS_SET = (0...123)

  def initialize(input, input_type)
    @input = input
    case input_type
    when :hex
      @input_bytes = @input.as_hex_to_bytes
    when :bytes
      @input_bytes = @input.bytes
    when :string
      @input_bytes = @input
    end
    run
  end

  def run
    @plaintext = PlaintextCollection.new
    ORDS_SET.each do |ord|
      code = Array.new(@input_bytes.length, ord)
      output_bytes = @input_bytes.as_bytes_xor_with(code)
      @plaintext.push(output_bytes.unbytes, @input)
    end
  end

  def best
    @plaintext.best
  end
end
