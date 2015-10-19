module CryptoUtils
  module_function

  def hex_to_base64(hex)
    bin_array_to_base64(hex_string_to_bin_array(hex))
  end

  def hex_xor(hex1, hex2)
    bin1 = hex_string_to_int(hex1)
    bin2 = hex_string_to_int(hex2)
    int_to_hex_string(bin1 ^ bin2)
  end

  def hex_string_to_bin_array(hex)
    hex.scan(/../).map(&:hex).pack('c*')
  end

  def bin_array_to_base64(hex)
    [hex].pack('m0')
  end

  def int_to_hex_string(int)
    int.to_s(16)
  end

  def hex_string_to_int(hex)
    hex.to_i(16)
  end
end
