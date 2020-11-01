require Dir.pwd + "/p-adic-crypto"

puts "Running Key Generation"
k = Gen.new(128)
puts "done!"

puts "Generating random plaintexts"
plaintexts = Array.new(16){ Tools.random_number(16)}
puts "done!"

puts "Generating ciphertexts"
ciphertexts = plaintexts.map{|plaintext| PAdicCrypto.encrypt(k,plaintext)}
puts "done!"

puts "Creating files with results"

File.open("data/samples_1.data", 'w') do |file|
  file.write("Plaintexts:\n\n")
  plaintexts.each_with_index do |plaintext,i|
    file.write("plaintext: #{plaintext}, ciphertext: #{ciphertexts[i]}\n\n")
  end
end
puts "done!"
