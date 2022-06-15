# frozen_string_literal: true

require_relative 'wagon'
require_relative 'passenger_wagon'
require_relative 'cargo_wagon'
require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'route'
require_relative 'station'

class RailwayManager
  def initialize
    @stations_list = []
    @trains_list = []
    @routes_list = []
    @wagons_list = []
  end

  def menu
    command_number = 1
    while command_number != 0
      puts 'Введите номер из списка для выполнения необходимой команды'
      puts '1. Создать станцию'
      puts '2. Создать поезд'
      puts '3. Создать маршрут'
      puts '4. Создать вагон'
      puts '5 Добавить станцию в существующий маршрут'
      puts '6 Удалить станцию из существующего маршрута'
      puts '7. Назначить маршрут поезду'
      puts '8. Добавлить вагон к поезду'
      puts '9. Отцепить вагон от поезда'
      puts '10. Переместить поезд по маршруту вперед'
      puts '11 Переместить поезд по маршруту назад'
      puts '12. Просмотреть список станций'
      puts '13. Просмотреть список поездов на станции'
      puts '14. Посмотреть список вагонов у поезда'
      puts '15. Занять место в вагоне'
      puts '0. Выход из программы'
      command_number = gets.chomp.to_i
      find_command(command_number)
    end
  end

  private

  def find_command(command_number)
    commands[command_number].call
  rescue NoMethodError
    puts 'Неверный номер команды'
  end

  def commands
    { 1 => method(:create_station), 2 => method(:create_train_interface),
      3 => method(:create_route), 4 => method(:create_wagon_interface),
      5 => method(:add_station_to_route), 6 => method(:delete_station_from_route),
      7 => method(:add_route_to_train), 8 => method(:hook_wagon),
      9 => method(:unhook_wagon), 10 => method(:move_train_next),
      11 => method(:move_train_back), 12 => method(:view_stations_list),
      13 => method(:view_trains_list_in_station), 14 => method(:view_wagons_list_in_train),
      15 => method(:take_place), 0 => method(:exit) }
  end

  # Station block
  def create_station
    puts 'Введите название станции'
    name = gets.chomp
    @stations_list << Station.new(name)
    puts 'Станция успешно создана!'
  rescue RuntimeError => e
    puts e.message
  end

  def view_stations_list
    @stations_list.each { |station| puts station.name }
  end

  def view_trains_list_in_station
    puts 'Введите название станции для вывода списка поездов' \
         " из имеющихся вариантов: #{extract_names(@stations_list).join(', ')}"
    station_name = gets.chomp
    station = find_station(name: station_name)

    puts 'Станция с данным названием не найден!' and return if station.nil?

    if station.trains_list.empty?
      puts 'На данной станции отсутствуют поезда!'
    else
      station.each_train do |train|
        puts "Номер: #{train.number}, тип: #{train.type}, число вагонов: #{train.wagons.count}"
      end
    end
  end

  # Train block
  def create_train_interface
    puts 'Введите номер подходящего по типу поезда: 1. Пассажирский, 2. Грузовой'
    train_type = gets.chomp.to_i

    if train_type != 1 && train_type != 2
      puts 'Номер не существует. Проверьте правильность введенных данных!'
      return
    end

    puts 'Введите номер поезда'
    number = gets.chomp

    @trains_list << create_train(type: train_type, number: number)

    puts 'Поезд успешно создан!'
  rescue RuntimeError => e
    puts e.message
    retry
  end

  def create_train(type:, number:)
    case type
    when 1
      PassengerTrain.new(number)
    when 2
      CargoTrain.new(number)
    end
  end

  def add_route_to_train
    puts 'Для назначения маршрута введите номер поезда' \
         " из имеющихся вариантов: #{extract_numbers(@trains_list).join(', ')}"
    train_number = gets.chomp
    train = find_train(number: train_number)

    puts 'Поезд с данным номером отсутствует!' and return if train.nil?

    puts "Введите название маршрута из имеющихся вариантов: #{extract_names(@routes_list).join(', ')}"
    route_name = gets.chomp
    route = find_route(name: route_name)

    puts 'Маршрут с данным названием не найден!' and return if route.nil?

    if train.add_route(route)
      puts 'Маршрут успешно добавлен!'
    else
      puts 'Маршрут уже назначен поезду. Повторное добавление невозможно!'
    end
  end

  def move_train_next
    puts 'Для перемещения поезда на следующую станцию введите номер поезда' \
         " из предложенных вариантов: #{extract_numbers(@trains_list).join(', ')}"
    train_number = gets.chomp
    train = find_train(number: train_number)

    puts 'Поезд с данным номером не найден!' and return if train.nil?

    if train.current_station.nil?
      puts 'Для данного поезда не назначен маршрут. Передвижение вперед невозможно!'
      return
    end

    train.move_next
    puts 'Поезд успешно перемещен вперед!'
  rescue RuntimeError => e
    puts e.message
  end

  def move_train_back
    puts 'Для перемещения поезда на предыдущую станцию введите номер поезда' \
         " из предложенных вариантов: #{extract_numbers(@trains_list).join(', ')}"
    train_number = gets.chomp
    train = find_train(number: train_number)

    puts 'Поезд с данным номером не найден!' and return if train.nil?

    if train.current_station.nil?
      puts 'Для данного поезда не назначен маршрут. Передвижение назад невозможно!'
      return
    end

    train.move_back
    puts 'Поезд успешно перемещен назад!'
  rescue RuntimeError => e
    puts e.message
  end

  def view_wagons_list_in_train
    puts 'Введите номер поезда для вывода списка вагонов' \
         " из имеющихся вариантов: #{extract_numbers(@trains_list).join(', ')}"
    train_number = gets.chomp
    train = find_train(number: train_number)

    puts 'Поезд с данным номером не найден!' and return if train.nil?

    puts 'У данного поезда отсутсвуют вагоны!' and return if train.wagons.empty?

    if train.type == 'пассажирский'
      train.each_wagon { |wagon| puts "#{wagon.number}, #{wagon.type}, #{wagon.taken_seats}, #{wagon.free_seats}" }
    else
      train.each_wagon do |wagon|
        puts "#{wagon.number}, #{wagon.type}, #{wagon.taken_volume}, #{wagon.available_volume}"
      end
    end
  end

  # Route block
  def create_route
    puts "Введите название первой станции маршрута из имеющихся вариантов: #{extract_names(@stations_list).join(', ')}"
    first_station_name = gets.chomp
    first_station = find_station(name: first_station_name)

    puts 'Введите название последней станции маршрута из' \
         " имеющихся вариантов: #{extract_names(@stations_list).join(', ')}"
    last_station_name = gets.chomp
    last_station = find_station(name: last_station_name)

    puts 'Введите номер маршрута'
    name = gets.chomp

    @routes_list << Route.new(first_station, last_station, name)
    puts 'Маршрут успешно создан!'
  rescue RuntimeError => e
    puts e.message
  end

  def add_station_to_route
    puts 'Для добавления промежуточной станции введите название маршрута' \
         " из имеющихся вариантов:  #{extract_names(@routes_list).join(', ')}"
    route_name = gets.chomp
    route = find_route(name: route_name)

    puts 'Маршрут не найден!' and return if route.nil?

    puts "Введите название промежуточной станции из имеющихся вариантов:  #{extract_names(@stations_list).join(', ')}"
    intermediate_station_name = gets.chomp
    intermediate_station = find_station(name: intermediate_station_name)

    puts 'Станция не найдена!' and return if intermediate_station.nil?

    if route.add_station(intermediate_station)
      puts 'Станция успешно добавлена!'
    else
      puts 'Станция уже включена в маршрут. Повторное добавление невозможно!'
    end
  end

  def delete_station_from_route
    puts 'Для удаления промежуточной станции введите название маршрута' \
         " из имеющихся вариантов: #{extract_names(@routes_list).join(', ')}"
    route_name = gets.chomp
    route = find_route(name: route_name)

    puts 'Маршрут не найден!' and return if route.nil?

    puts "Введите название промежуточной станции из имеющихся вариантов:  #{extract_names(@stations_list).join(', ')}"
    intermediate_station_name = gets.chomp
    intermediate_station = find_station(name: intermediate_station_name)

    puts 'Станция не найдена!' and return if intermediate_station.nil?

    unless route.stations_list.include?(intermediate_station)
      puts 'В маршрут не включена запрашиваемая станция!'
      return
    end

    if route.delete_station(intermediate_station)
      puts 'Станция успешно удалена!'
    else
      puts 'Станция не может быть удалена, т.к. является первой или последней в маршруте!'
    end
  end

  # Wagon block
  def create_wagon_interface
    puts 'Введите номер подходящего типа для создания вагона: 1. Пассажирский, 2. Грузовой'
    wagon_type = gets.chomp.to_i

    if wagon_type != 1 && wagon_type != 2
      puts 'Номер не существует. Проверьте правильность введенных данных!'
      return
    end

    puts 'Введите номер вагона'
    number = gets.chomp

    @wagons_list << create_wagon(type: wagon_type, number: number)

    puts 'Вагон успешно создан!'
  rescue RuntimeError => e
    puts e.message
  end

  def create_wagon(type:, number:)
    case type
    when 1
      puts 'Введите количество посадочных мест'
      total_seats_number = gets.chomp.to_i
      PassengerWagon.new(number, total_seats_number)
    when 2
      puts 'Введите объем вагона'
      total_volume = gets.chomp.to_f
      CargoWagon.new(number, total_volume)
    end
  end

  def hook_wagon
    puts 'Для присоединения вагона введите номер поезда' \
         " из имеющихся вариантов: #{extract_numbers(@trains_list).join(', ')}"
    train_number = gets.chomp
    train = find_train(number: train_number)

    puts 'Поезд не найден!' and return if train.nil?

    puts "Введите номер присоединяемого вагона из имеющихся вариантов: #{extract_numbers(@wagons_list).join(', ')}"
    wagon_number = gets.chomp
    wagon = find_wagon(number: wagon_number)

    puts 'Вагон с данным номером не найден!' and return if wagon.nil?

    train.hook_wagon(wagon)
    puts 'Вагон упешно прицеплен!'
  rescue RuntimeError => e
    puts e.message
  end

  def unhook_wagon
    puts 'Для отсоединения вагона введите номер поезда' \
         " из имеющихся вариантов: #{extract_numbers(@trains_list).join(', ')}"
    train_number = gets.chomp
    train = find_train(number: train_number)

    puts 'Поезд не найден!' and return if train.nil?

    puts "Введите номер отсоединяемого вагона из имеющихся вариантов: #{extract_numbers(@wagons_list).join(', ')}"
    wagon_number = gets.chomp
    wagon = find_wagon(number: wagon_number)

    puts 'Вагон с данным номером не найден!' and return if wagon.nil?

    train.unhook_wagon(wagon)
    puts 'Вагон успешно отцеплен!'
  rescue RuntimeError => e
    puts e.message
  end

  def take_place
    puts "Введите номер поезда из имеющихся вариантов: #{extract_numbers(@trains_list).join(', ')}"
    train_number = gets.chomp
    train = find_train(number: train_number)

    puts 'Поезд с данным номером не найден!' and return if train.nil?

    puts "Введите номер вагона из имеющихся вариантов: #{extract_numbers(train.wagons).join(', ')}"
    wagon_number = gets.chomp
    wagon = train.wagons.find { |w| w.number == wagon_number }

    if wagon.empty?
      puts 'У данного поезда отсутствует вагон с таким номером'
      return
    end

    if wagon.type == 'пассажирский'
      train.take_seat
      puts 'Место успешно зарезервировано!'
    else
      train.take_volume
      puts 'Объем в вагоне занят успешно!'
    end
  rescue RuntimeError => e
    puts e.message
  end

  # Helpers
  def extract_names(array)
    array.map(&:name)
  end

  def extract_numbers(array)
    array.map(&:number)
  end

  def find_station(name:)
    @stations_list.find { |station| station.name == name }
  end

  def find_route(name:)
    @routes_list.find { |route| route.name == name }
  end

  def find_train(number:)
    @trains_list.find { |train| train.number == number }
  end

  def find_wagon(number:)
    @wagons_list.find { |wagon| wagon.number == number }
  end
end
