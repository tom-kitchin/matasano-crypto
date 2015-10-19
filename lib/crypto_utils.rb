module CryptoUtils
  module_function

  def hex_to_base64(hex)
    bin_to_base64(hex_to_bin(hex))
  end

  def bin_to_base64(hex)
    [hex].pack('m0')
  end

  def bin_to_hex(bin)
    bin.unpack('H*').first
  end

  def hex_to_bin(hex)
    hex.scan(/../).map(&:hex).pack('c*')
  end
end
