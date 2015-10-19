require 'plaintext'
require 'crypto_utils'
require 'hex_string'
require 'pp'

RSpec.describe Plaintext do
  it 'generates a plaintext score based on character commonality' do
    pt = Plaintext.new('zqxj')
    expect(pt.score_by_english_letter_frequency).to eq(6)
  end
end

RSpec.describe PlaintextCollection do
  it 'acquires the plaintext with highest score' do
    ptc = PlaintextCollection.new
    ptc.push('zqxj')
    ptc.push('zja')
    ptc.push('etaoin')

    expect(ptc.best.to_s).to eq('etaoin')
  end
end

RSpec.describe :Challenge3 do
  source = '1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736'
  alphaset = (0...36).map { |i| i.to_s 36 }

  # it 'XORs the hex with each character in the alphabet' do
  #   alphaset.each do |char|
  #     code = char.to_hex_string * (source.length / 2)
  #     hex = CryptoUtils.hex_xor(source, code)
  #   end
  # end

  # it 'creates a nice ordered list of score pairs' do
  #   ptc = PlaintextCollection.new
  #   alphaset.each do |char|
  #     code = char.to_hex_string * (source.length / 2)
  #     hex = CryptoUtils.hex_xor(source, code)
  #     ptc.push(hex.to_byte_string)
  #   end

  #   score_pairs = {}
  #   ptc.each do |pt|
  #     score_pairs[pt.to_s] = pt.score
  #   end
  #   pp score_pairs.sort_by { |_k, v| v }
  # end

  it 'creates the list of plaintext and finds the best match' do
    ptc = PlaintextCollection.new
    alphaset.each do |char|
      code = char.to_hex_string * (source.length / 2)
      hex = CryptoUtils.hex_xor(source, code)
      ptc.push(hex.to_byte_string)
    end
    expect(ptc.best.to_s).to eq('cOOKING_mc_S_LIKE_A_POUND_OF_BACON')
  end
end
