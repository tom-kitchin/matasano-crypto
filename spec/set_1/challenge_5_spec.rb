require 'repeating_key_xor'

RSpec.describe :Challenge5 do
  it 'encrypts the given string with repeating-key XOR' do
    crypt = RepeatingKeyXor.new('ICE')
    plaintext = "Burning 'em, if you ain't quick and nimble"
    cyphertext = '0b3637272a2b2e63622c2e69692a23693a2a3c6324202d623d63343c2a26226324272765272a282b2f20'
    expect(crypt.encrypt(plaintext)).to eq(cyphertext)
  end

  it 'encrypts the given multiline string with repeating-key XOR' do
    crypt = RepeatingKeyXor.new('ICE')
    plaintext = "Burning 'em, if you ain't quick and nimble\nI go crazy when I hear a cymbal"
    cyphertext = '0b3637272a2b2e63622c2e69692a23693a2a3c6324202d623d63343c2a26' \
      '226324272765272a282b2f20430a652e2c652a3124333a653e2b2027630c692b20283165286326302e27282f'
    expect(crypt.encrypt(plaintext)).to eq(cyphertext)
  end
end
