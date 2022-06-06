require_relative 'instance_counter'

class Station
  include InstanceCounter
  attr_reader :trains_list, :name

  @@all_stations = []

  def self.all
    @@all_stations
  end

  def initialize(name)
    @name = name
    @trains_list = []
    @@all_stations << self
    register_instance
  end

  def take_train(train)
    @trains_list << train unless @trains_list.include?(train)
  end

  def send_train(train)
    @trains_list.delete(train)
  end

  def trains_list_by_type(type)
    @trains_list.select { |train| train.type == type }
  end

  def trains_quantity_by_type(type)
    @trains_list.count { |train| train.type == type }
  end
end
