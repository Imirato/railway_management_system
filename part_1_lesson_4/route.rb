class Route
  attr_reader :stations_list, :first_station, :last_station

  def initialize(first_station, last_station)
    @first_station = first_station
    @last_station = last_station
    @stations_list = [first_station, last_station]
  end

  def add_station(station)
    @stations_list.insert(-2, station)
  end

  def delete_station(station)
    @stations_list.delete(station) if station != @first_station && station != @last_station
  end
end
