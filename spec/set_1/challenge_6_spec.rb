require 'repeating_key_xor_decryptor'

RSpec.describe RepeatingKeyXorDecryptor do
  it 'initializes data to bytes' do
    bytes = [104, 101, 108, 108, 111]
    string = 'hello'
    hex = '68656c6c6f'
    base64 = 'aGVsbG8='

    expect(RepeatingKeyXorDecryptor.new(bytes, :bytes).input_bytes).to eq(bytes)
    expect(RepeatingKeyXorDecryptor.new(hex, :hex).input_bytes).to eq(bytes)
    expect(RepeatingKeyXorDecryptor.new(base64, :base64).input_bytes).to eq(bytes)
    expect(RepeatingKeyXorDecryptor.new(string, :string).input_bytes).to eq(bytes)
  end

  it 'extracts the most likely keysize' do
    key = 'ICE'
    ciphertext = '0b3637272a2b2e63622c2e69692a23693a2a3c6324202d623d63343c2a26226324272765272a282b2f20'
    decryptor = RepeatingKeyXorDecryptor.new(ciphertext, :hex)

    expect(decryptor.seek_keysize).to include(key.length)
  end

  it 'breaks the input bytes into equally sized blocks, padding with zeroes' do
    bytes = (1..8)
    decryptor = RepeatingKeyXorDecryptor.new(bytes, :bytes)

    blocks_size_two = decryptor.break_ciphertext_into_blocks(2)
    expect(blocks_size_two.size).to eq(4)
    expect(blocks_size_two.first).to eq([1, 2])
    expect(blocks_size_two.last).to eq([7, 8])

    blocks_size_three = decryptor.break_ciphertext_into_blocks(3)
    expect(blocks_size_three.size).to eq(3)
    expect(blocks_size_three.first).to eq([1, 2, 3])
    expect(blocks_size_three.last).to eq([7, 8, 0])
  end

  it 'breaks a transposed block by treating it as single character XOR' do
    key = 'ICE'
    ciphertext = '0b3637272a2b2e63622c2e69692a23693a2a3c6324202d623d63343c2a26226324272765272a282b2f20'
    decryptor = RepeatingKeyXorDecryptor.new(ciphertext, :hex)

    keysize_blocks = decryptor.break_ciphertext_into_blocks(key.length)
    transposed_blocks = keysize_blocks.transpose
    expect(decryptor.guess_keys_for_transposed_block(transposed_blocks.first)).to include('I'.ord)
  end

  it 'collects all plausible keys for a keysize' do
    key = 'ICE'
    ciphertext = '0b3637272a2b2e63622c2e69692a23693a2a3c6324202d623d63343c2a26226324272765272a282b2f20'
    decryptor = RepeatingKeyXorDecryptor.new(ciphertext, :hex)

    expect(decryptor.collect_possible_keys_for_keysize(key.length)).to include(key)
  end

  it 'guesses keys and tries to decrypt with them' do
    key = 'ICE'
    ciphertext = '0b3637272a2b2e63622c2e69692a23693a2a3c6324202d623d63343c2a26226324272765272a282b2f20'
    plaintext = "Burning 'em, if you ain't quick and nimble"
    decryptor = RepeatingKeyXorDecryptor.new(ciphertext, :hex)

    expect(decryptor.solve_with_keysize(key.length).map(&:text)).to include(plaintext)
  end

  it 'tries to decrypt with the best fit keys/keysizes' do
    key = 'ICE'
    ciphertext = '0b3637272a2b2e63622c2e69692a23693a2a3c6324202d623d63343c2a26226324272765272a282b2f20'
    plaintext = "Burning 'em, if you ain't quick and nimble"
    decryptor = RepeatingKeyXorDecryptor.new(ciphertext, :hex)

    expect(decryptor.decrypt.map(&:text)).to include(plaintext)
  end
end

RSpec.describe :Challenge6 do
  it 'breaks the key for a repeating-key XOR encrypted file' do
    input_file = 'assets/set_1/challenge_6.txt'
    ciphertext = ''
    File.foreach(input_file) do |line|
      ciphertext << line.chomp
    end

    decryptor = RepeatingKeyXorDecryptor.new(ciphertext, :base64)
    # puts decryptor.decrypt.best
  end
end
