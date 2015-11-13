require 'crypto_utils'

RSpec.describe :Challenge2 do
  it 'XORs two equal-length hex strings' do
    hex1 = '1c0111001f010100061a024b53535009181c'
    hex2 = '686974207468652062756c6c277320657965'
    expect(hex1.as_hex_xor_with(hex2)).to eq('746865206b696420646f6e277420706c6179')
  end
end
