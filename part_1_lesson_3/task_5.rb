puts "Введите число"
day = gets.chomp

puts "Введите месяц"
month = gets.chomp

puts "Введите год"
year = gets.chomp

calendar = { "january" => 31, "february" => 28, "march" => 31,
             "april" => 30, "may" => 31, "june" => 30,
             "july" => 31, "august" => 31, "september" => 30,
             "october" => 31, "november" => 30, "december" => 31 }

if (year % 4 == 0 && year % 100 != 0) || (year % 4 == 0 && year % 100 == 0 && year % 400 == 0)
  calendar["february"] = 29
end

count = calendar.values.first(month - 1).sum + day

puts count
