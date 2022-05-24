alphabet = ('a'..'z').to_a
vowels = ["a", "e", "i", "o", "y"]
hash = {}

vowels.each do |vowel|
  hash[vowel] = alphabet.index(vowel) + 1
end

puts hash
