# frozen_string_literal: true

require_relative 'modules/manufacturer_name'
require_relative 'modules/instance_counter'
require_relative 'modules/validation'

class Train
  include ManufacturerName
  include InstanceCounter
  include Validation

  NUMBER_FORMAT = /^([а-я]|\d){3}-*([а-я]|\d){2}$/i.freeze

  attr_reader :speed, :wagons, :current_station, :next_station, :previous_station, :number

  attr_accessor_with_history :var1, :var2
  strong_attr_accessor :var3, String

  validate :number, :presence
  validate :number, :format, NUMBER_FORMAT

  def initialize(number)
    @number = number
    @wagons = []
    @speed = 0
    validate!
    @@all_trains << self
    register_instance
  end

  def speed_increase(speed)
    @speed += speed if speed.positive?
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
    @current_station&.send_train(self)
    @route = route
    @route.first_station.take_train(self)
    @current_station = @route.first_station
    @next_station = @route.stations_list[1]
  end

  def move_next
    raise 'Поезд находится на последней станции. Движение вперед невозможно!' if @current_station == @route.last_station

    @current_station.send_train(self)
    @next_station.take_train(self)

    @previous_station = @current_station
    @current_station = @next_station
    @next_station = @route.stations_list[@route.stations_list.index(@current_station) + 1]
  end

  def move_back
    raise 'Поезд находится на первой станции. Движение назад невозможно!' if @current_station == @route.first_station

    @current_station.send_train(self)
    @previous_station.take_train(self)

    @next_station = @current_station
    @current_station = @previous_station
    @previous_station = @route.stations_list[@route.stations_list.index(@current_station) - 1]
  end

  def each_wagon(&block)
    @wagons.each { |wagon| block.call(wagon) }
  end
end
