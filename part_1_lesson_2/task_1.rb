puts "Как Вас зовут?"
name = gets.chomp.capitalize
puts "Какой у Вас рост в сантиментрах?"
high = gets.chomp.to_i
ideal_weight = (high - 110) * 1.15
if ideal_weight < 0
  puts "#{name}, Ваш вес уже оптимальный"
else
  puts "#{name}, Ваш оптимальный вес #{ideal_weight} "
end
