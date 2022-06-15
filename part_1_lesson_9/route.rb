# frozen_string_literal: true

require_relative 'modules/instance_counter'
require_relative 'modules/validation'

class Route
  include InstanceCounter
  include Validation

  NUMBER_FORMAT = /^\S/.freeze

  attr_reader :stations_list, :first_station, :last_station, :name

  def initialize(first_station, last_station, name)
    @first_station = first_station
    @last_station = last_station
    @stations_list = [first_station, last_station]
    @name = name
    validate!
    register_instance
  end

  def add_station(station)
    @stations_list.insert(-2, station) unless @stations_list.include?(station)
  end

  def delete_station(station)
    @stations_list.delete(station) if station != @first_station && station != @last_station
  end

  protected

  def validate!
    raise 'Станция с таким названием не найдена!' unless @first_station.is_a?(Station) && @last_station.is_a?(Station)
    raise 'Неверно указано название маршрута!' if @name !~ NUMBER_FORMAT

    true
  end
end
