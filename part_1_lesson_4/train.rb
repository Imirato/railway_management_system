class Train
  attr_reader :speed, :wagons_quantity, :current_station, :next_station, :previous_station, :type

  TRAIN_TYPES = %w[грузовой пассажирский]

  def initialize(number, type, wagons_quantity)
    @number = number
    @type = type
    @wagons_quantity = wagons_quantity
    @speed = 0

    validate_train
  end

  def validate_train
    raise "Количество вагонов не может быть отрицательным числом!" if @wagons_quantity < 0
    raise "Неверный тип поезда!" unless TRAIN_TYPES.include?(@type)
  end

  def speed_increase(speed)
    @speed += speed if speed > 0
  end

  def stop
    @speed = 0
  end

  def hook_wagon
    @wagons_quantity += 1 if @speed.zero?
  end

  def unhook_wagon
    @wagons_quantity -= 1 if @speed.zero? && @wagons_quantity > 0
  end

  def add_route(route)
    @current_station.send_train(self) if @current_station
    @route = route
    @route.first_station.take_train(self)
    @current_station = @route.first_station
    @next_station = @route.stations_list[1]
  end

  def move_next
    return if @current_station == @route.last_station

    @current_station.send_train(self)
    @next_station.take_train(self)

    @previous_station = @current_station
    @current_station = @next_station
    @next_station = @route.stations_list[@route.stations_list.index(@current_station) + 1]
  end

  def move_back
    return if @current_station == @route.first_station

    @current_station.send_train(self)
    @previous_station.take_train(self)

    @next_station = @current_station
    @current_station = @previous_station
    @previous_station = @route.stations_list[@route.stations_list.index(@current_station) - 1]
  end
end
