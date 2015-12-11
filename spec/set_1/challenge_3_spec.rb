require 'single_character_xor_decryptor'
require 'crypto_utils'
require 'pp'

RSpec.describe Plaintext do
  it 'generates a plaintext score based on character commonality' do
    pt = Plaintext.new('abc')
    expect(pt.score_by_english_letter_frequency).to eq(0.0993325)
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

  # it 'XORs the hex with each character in the alphabet' do
  #   ords_set.each do |ord|
  #     code = Array.new(source_bytes.length, ord)
  #     hex = source_bytes.as_bytes_xor_with(code)
  #     # puts hex.unbytes
  #   end
  # end

  # it 'creates a nice ordered list of score pairs' do
  #   ptc = PlaintextCollection.new
  #   ords_set.each do |ord|
  #     code = Array.new(source_bytes.length, ord)
  #     hex = source_bytes.as_bytes_xor_with(code)
  #     ptc.push hex.unbytes
  #   end
  #   score_pairs = {}
  #   ptc.each do |pt|
  #     score_pairs[pt.to_s] = pt.score
  #   end
  #   pp score_pairs.sort_by { |_k, v| v }
  # end

  it 'creates the list of plaintext and finds the best match' do
    scx = SingleCharacterXorDecryptor.new(source, :hex)
    expect(scx.best.text).to eq("Cooking MC's like a pound of bacon")
  end
end
