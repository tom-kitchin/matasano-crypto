require 'single_character_xor_decryptor'
require 'plaintext'

RSpec.describe :Challenge4 do
  input_file = 'assets/set_1/challenge_4.txt'

  it 'checks the hex and match for the hex with the best match in single character XOR' do
    ptc = PlaintextCollection.new
    File.foreach(input_file) do |line|
      line = line.chomp
      scx = SingleCharacterXorDecryptor.new(line, :hex)
      ptc.push scx.best
    end
    expect(ptc.best.source).to eq('7b5a4215415d544115415d5015455447414c155c46155f4058455c5b523f')
    expect(ptc.best.text).to eq("Now that the party is jumping\n")
  end
end
