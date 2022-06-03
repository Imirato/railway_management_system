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
    while command_number != 0 do
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
      puts '0. Выход из программы'
      command_number = gets.chomp.to_f
      find_command(command_number)
    end
  end

  # методы предназначены только для внутреннего использования
  private

  def find_command(command_number)
    case command_number
    when 1
      create_station
    when 2
      create_train
    when 3
      create_route
    when 4
      create_wagon
    when 5
      add_station_to_route
    when 6
      delete_station_from_route
    when 7
      add_route_to_train
    when 8
      hook_wagon
    when 9
      unhook_wagon
    when 10
      move_train_next
    when 11
      move_train_back
    when 12
      view_stations_list
    when 13
      view_trains_list_in_station
    when 0
      nil
    else
      puts 'Неверный номер команды'
    end
  end

  def create_station
    puts 'Введите название станции'
    name = gets.chomp
    @stations_list << Station.new(name)
  end

  def create_train
    puts 'Выберите и введите номер подходящего по типу поезда: 1. Пассажирский, 2. Грузовой'
    train_type = gets.chomp.to_i

    if train_type != 1 && train_type != 2
      puts "Номер не существует. Проверьте правильность введенных данных!"
      return
    end

    puts 'Введите номер поезда'
    number = gets.chomp
    case train_type
    when 1
      @trains_list << PassengerTrain.new(number)

    when 2
      @trains_list << CargoTrain.new(number)
    end
  end

  def create_route
    puts "Выберите и введите название первой станции маршрута из имеющихся вариантов: #{extract_names(@stations_list).join(", ")}"
    first_station_name = gets.chomp
    first_station = @stations_list.find { |station| station.name == first_station_name }

    puts "Выберите и введите название последней станции маршрута из имеющихся вариантов: #{extract_names(@stations_list).join(", ")}"
    last_station_name = gets.chomp
    last_station = @stations_list.find { |station| station.name == last_station_name }

    puts "Введите номер маршрута"
    name = gets.chomp
    @routes_list << Route.new(first_station, last_station, name)
  end

  def create_wagon
    puts 'Введите номер подходящего типа для создания вагона: 1. Пассажирский, 2. Грузовой'
    wagon_type = gets.chomp.to_i

    if wagon_type != 1 && wagon_type != 2
      puts "Номер не существует. Проверьте правильность введенных данных!"
      return
    end

    puts 'Введите номер вагона'
    number = gets.chomp

    case wagon_type
    when 1
      @wagons_list << PassengerWagon.new(number)
      puts "Вагон успешно создан!"

    when 2
      @wagons_list << CargoWagon.new(number)
      puts "Вагон успешно создан!"
    end
  end

  def add_station_to_route
    puts "Для добавления промежуточной станции выберите и введите название маршрута из имеющихся вариантов:  #{extract_names(@routes_list).join(", ")}"
    route_name = gets.chomp
    route = @routes_list.find { |route| route.name == route_name }

    if route.nil?
      puts "Маршрут не найден!"
      return
    end

    puts "Выберите и введите название промежуточной станции из имеющихся вариантов:  #{extract_names(@stations_list).join(", ")}"
    intermediate_station_name = gets.chomp
    intermediate_station = @stations_list.find { |station| station.name == intermediate_station_name }

    if intermediate_station.nil?
      puts "Станция не найдена!"
      return
    end

    if route.add_station(intermediate_station)
      puts "Станция успешно добавлена!"
    else
      puts "Станция уже включена в маршрут. Повторное добавление невозможно!"
    end
  end

  def delete_station_from_route
    puts "Для удаления промежуточной станции выберите и введите название маршрута из имеющихся вариантов:  #{extract_names(@routes_list).join(", ")}"
    route_name = gets.chomp
    route = @routes_list.find { |route| route.name == route_name }

    if route.nil?
      puts "Маршрут не найден!"
      return
    end

    puts "Выберите и введите название промежуточной станции из имеющихся вариантов:  #{extract_names(@stations_list).join(", ")}"
    intermediate_station_name = gets.chomp
    intermediate_station = @stations_list.find { |station| station.name == intermediate_station_name }

    if intermediate_station.nil?
      puts "Станция не найдена!"
      return
    end

    unless route.stations_list.include?(intermediate_station)
      puts "В маршрут не включена запрашиваемая станция!"
      return
    end

    if route.delete_station(intermediate_station)
      puts "Станция успешно удалена!"
    else
      puts "Станция не может быть удалена, т.к. является первой или последней в маршруте!"
    end
  end

  def add_route_to_train
    puts "Для назначения маршрута выберите и введите номер поезда из имеющихся вариантов: #{extract_numbers(@trains_list).join(", ")}"
    train_number = gets.chomp
    train = @trains_list.find { |train| train.number == train_number }

    if train.nil?
      puts "Поезд с данным номером отсутствует!"
      return
    end

    puts "Выберите и введите название маршрута из имеющихся вариантов: #{extract_names(@routes_list).join(", ")}"
    route_name = gets.chomp
    route = @routes_list.find { |route| route.name == route_name }

    if route.nil?
      puts "Маршрут с данным названием не найден!"
      return
    end

    if train.add_route(route)
      puts "Маршрут успешно добавлен!"
    else
      puts "Маршрут уже назначен поезду. Повторное добавление невозможно!"
    end
  end

  def hook_wagon
    puts "Для присоединения вагона выберите и введите номер поезда из имеющихся вариантов: #{extract_numbers(@trains_list).join(", ")}"
    train_name = gets.chomp
    train = @trains_list.find { |train| train.number == train_name }

    if train.nil?
      puts "Поезд не найден!"
      return
    end

    puts "Выберите и введите номер присоединяемого вагона из имеющихся вариантов: #{extract_numbers(@wagons_list).join(", ")}"
    wagon_number = gets.chomp
    wagon = @wagons_list.find { |wagon| wagon.number == wagon_number }

    if wagon.nil?
      puts "Вагон с данным номером не найден!"
      return
    end

    begin
      train.hook_wagon(wagon)
      puts "Вагон упешно прицеплен!"
    rescue RuntimeError => error
      puts error.message
    end
  end

  def unhook_wagon
    puts "Для отсоединения вагона выберите и введите номер поезда из имеющихся вариантов: #{extract_numbers(@trains_list).join(", ")}"
    train_name = gets.chomp
    train = @trains_list.find { |train| train.number == train_name }

    if train.nil?
      puts "Поезд не найден!"
      return
    end

    puts "Выберите и введите номер отсоединяемого вагона из имеющихся вариантов: #{extract_numbers(@wagons_list).join(", ")}"
    wagon_number = gets.chomp
    wagon = @wagons_list.find { |wagon| wagon.number == wagon_number }

    if wagon.nil?
      puts "Вагон с данным номером не найден!"
      return
    end

    begin
      train.unhook_wagon(wagon)
      puts "Вагон успешно отцеплен!"
    rescue RuntimeError => error
      puts error.message
    end
  end

  def move_train_next
    puts "Для перемещения поезда на следующую станцию выберите и введите номер поезда из предложенных вариантов: #{extract_numbers(@trains_list).join(", ")}"
    train_name = gets.chomp
    train = @trains_list.find { |train| train.number == train_name }

    if train.nil?
      puts "Поезд с данным номером не найден!"
      return
    end

    if train.current_station.nil?
      puts "Для данного поезда не назначен маршрут. Передвижение вперед невозможно!"
      return
    end

    begin
      train.move_next
      puts "Поезд успешно перемещен вперед!"
    rescue RuntimeError => error
      puts error.message
    end
  end

  def move_train_back
    puts "Для перемещения поезда на предыдущую станцию выберите и введите номер поезда из предложенных вариантов: #{extract_numbers(@trains_list).join(", ")}"
    train_name = gets.chomp
    train = @trains_list.find { |train| train.number == train_name }

    if train.nil?
      puts "Поезд с данным номером не найден!"
      return
    end

    if train.current_station.nil?
      puts "Для данного поезда не назначен маршрут. Передвижение вперед невозможно!"
      return
    end

    begin
      train.move_back
      puts "Поезд успешно перемещен назад!"
    rescue RuntimeError => error
      puts error.message
    end
  end

  def view_stations_list
    @stations_list.each { |station| puts station.name }
  end

  def view_trains_list_in_station
    puts "Выберите и введите название станции для вывода списка поездов из имеющихся вариантов: #{extract_names(@stations_list).join(", ")}"
    station_name = gets.chomp
    station = @stations_list.find { |station| station.name == station_name }

    if station.nil?
      puts "Станция с данным названием не найден!"
      return
    end

    if station.trains_list.empty?
      puts "На данной станции отсутствуют поезда!"
    else
      station.trains_list.each { |train| puts train.number }
    end
  end

  def extract_names(array)
    array.map { |element| element.name }
  end

  def extract_numbers(array)
    array.map { |element| element.number }
  end
end
