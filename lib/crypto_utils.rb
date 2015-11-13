class String
  def to_base64
    [self].pack('m0')
  end

  def from_base64
    unpack('m0').first
  end

  def as_hex_to_bytes
    gsub(/\s+/, '').scan(/../).map { |pair| pair.to_i(16) }
  end

  def as_hex_to_base64
    as_hex_to_bytes.as_bytes_to_base64
  end

  def xor_with(other_string)
    bytes.as_bytes_xor_with(other_string.bytes).unbytes
  end

  def as_hex_xor_with(other_hex)
    as_hex_to_bytes.as_bytes_xor_with(other_hex.as_hex_to_bytes).as_bytes_to_hex
  end

  def hamming_distance_to(other_string)
    bytes.hamming_distance_to(other_string.bytes)
  end
end

class Array
  def unbytes
    pack('c*')
  end

  def as_bytes_to_hex
    map { |i| i.to_s(16).rjust(2, '0') }.join
  end

  def as_bytes_to_base64
    unbytes.to_base64
  end

  def as_bytes_xor_with(other_bytes)
    zip(other_bytes).map { |(a, b)| a ^ b }
  end

  def hamming_distance_to(other_bytes)
    as_bytes_xor_with(other_bytes).bit_count
  end

  def bit_count
    inject(0) { |acc, val| acc + val.bit_count }
  end
end

class Integer
  def bit_count
    to_s(2).count('1')
  end
end
