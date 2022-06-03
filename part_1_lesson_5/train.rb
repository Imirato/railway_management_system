class Train
  attr_reader :speed, :wagons, :current_station, :next_station, :previous_station, :number

  def initialize(number)
    @number = number
    @wagons = []
    @speed = 0
  end

  def speed_increase(speed)
    @speed += speed if speed > 0
  end

  def stop
    @speed = 0
  end

  def hook_wagon(wagon)
    raise 'Неверный тип вагона!' if wagon.type != @type
    raise 'Поезд в движении. Невозможно прицепить вагон!' unless @speed.zero?
    raise 'Данный вагон уже прицеплен!' if @wagons.include?(wagon)

    @wagons << wagon
  end

  def unhook_wagon(wagon)
    raise 'Все вагоны уже отцеплены!' if @wagons.empty?
    raise 'Поезд в движении. Невозможно отцепить вагон!' unless @speed.zero?

    @wagons.delete(wagon)
  end

  def add_route(route)
    @current_station.send_train(self) if @current_station
    @route = route
    @route.first_station.take_train(self)
    @current_station = @route.first_station
    @next_station = @route.stations_list[1]
  end

  def move_next
    raise "Поезд находится на последней станции. Движение вперед невозможно!" if @current_station == @route.last_station

    @current_station.send_train(self)
    @next_station.take_train(self)

    @previous_station = @current_station
    @current_station = @next_station
    @next_station = @route.stations_list[@route.stations_list.index(@current_station) + 1]
  end

  def move_back
    raise "Поезд находится на первой станции. Движение назад невозможно!"  if @current_station == @route.first_station

    @current_station.send_train(self)
    @previous_station.take_train(self)

    @next_station = @current_station
    @current_station = @previous_station
    @previous_station = @route.stations_list[@route.stations_list.index(@current_station) - 1]
  end

end
