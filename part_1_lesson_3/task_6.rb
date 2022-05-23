shopping_cart = {}

loop do
  puts "Введите название товара"
  product_name = gets.chomp

  break if product_name == "стоп"

  puts "Введите цену за единицу товара"
  product_price = gets.chomp.to_f

  puts "Введите количество товара"
  product_quantity = gets.chomp.to_i

  shopping_cart[product_name] = { product_price: product_price, product_quantity: product_quantity }
end

puts shopping_cart

total_price = 0

shopping_cart.each do |product_name, product_data|
  total_product_price = product_data[:product_price] * product_data[:product_quantity]
  total_price += total_product_price

  puts "#{product_name}: #{total_product_price}"
end

puts "Общая стоимость равна #{total_price}"