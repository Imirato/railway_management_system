require_relative 'instance_counter'

class Route
  include InstanceCounter
  attr_reader :stations_list, :first_station, :last_station, :name

  def initialize(first_station, last_station, name)
    @first_station = first_station
    @last_station = last_station
    @stations_list = [first_station, last_station]
    @name = name
    register_instance
  end

  def add_station(station)
    @stations_list.insert(-2, station) unless @stations_list.include?(station)
  end

  def delete_station(station)
    @stations_list.delete(station) if station != @first_station && station != @last_station
  end
end
