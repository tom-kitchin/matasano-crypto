require 'repeating_key_xor_decryptor'

RSpec.describe :Challenge6 do
  it 'breaks the key for a repeating-key XOR encrypted file' do
    input_file = 'assets/set_1/challenge_6.txt'
    cyphertext = ''
    File.foreach(input_file) do |line|
      cyphertext << line.chomp
    end

    decryptor = RepeatingKeyXorDecryptor.new(cyphertext, :base64)
  end
end
