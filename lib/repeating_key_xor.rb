require 'crypto_utils'

class RepeatingKeyXor
  attr_reader :key, :key_bytes

  def initialize(key)
    @key = key
    @key_bytes = key.bytes
  end

  def encrypt(plaintext)
    cypher_bytes = []
    plaintext_bytes = plaintext.chomp.bytes
    plaintext_bytes.each_slice(@key_bytes.length) do |slice|
      if slice.length < @key_bytes.length
        cypher_bytes.concat(slice.as_bytes_xor_with(@key_bytes.slice(0, slice.length)))
      else
        cypher_bytes.concat(slice.as_bytes_xor_with(@key_bytes))
      end
    end
    cypher_bytes.as_bytes_to_hex
  end
end
