require 'crypto_utils'

RSpec.describe :string_extensions do
  it 'converts string input to base64' do
    string = 'Hello, world'
    base64 = 'SGVsbG8sIHdvcmxk'
    expect(string.to_base64).to eq(base64)
  end

  it 'converts base64 to string' do
    string = 'Hello, world'
    base64 = 'SGVsbG8sIHdvcmxk'
    expect(base64.from_base64).to eq(string)
  end

  it 'converts a hex string to integer array' do
    string = '68656c6c6f'
    array = [104, 101, 108, 108, 111]
    expect(string.as_hex_to_bytes).to eq(array)
  end

  it 'converts a hex string to base64' do
    string = '48656c6c6f2c20776f726c64'
    base64 = 'SGVsbG8sIHdvcmxk'
    expect(string.as_hex_to_base64).to eq(base64)
  end
end

RSpec.describe :array_extensions do
  it 'converts bytes to string' do
    string = 'Hello, world'
    array = 'Hello, world'.bytes
    expect(array.unbytes).to eq(string)
  end

  it 'converts bytes to base64' do
    array = [104, 101, 108, 108, 111]
    base64 = 'aGVsbG8='
    expect(array.as_bytes_to_base64).to eq(base64)
  end

  it 'converts bytes to hex string' do
    array = [104, 101, 108, 108, 111]
    string = '68656c6c6f'
    expect(array.as_bytes_to_hex).to eq(string)
  end
end
