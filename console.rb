require 'pry'

$LOAD_PATH.unshift File.dirname(__FILE__)
$LOAD_PATH.unshift File.dirname(__FILE__) + '/lib'

def reload!
  Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| load file }
end

reload!

# Prep challenge 6 cyphertext
challenge_6 = ''
File.foreach('assets/set_1/challenge_6.txt') do |line|
  challenge_6 << line.chomp
end

binding.pry

puts 'loaded'
