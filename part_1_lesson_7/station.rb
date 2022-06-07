require_relative 'instance_counter'
require_relative 'validation'

class Station
  include InstanceCounter
  include Validation

  NUMBER_FORMAT = /^\S/

  attr_reader :trains_list, :name

  @@all_stations = []

  def self.all
    @@all_stations
  end

  def initialize(name)
    @name = name
    @trains_list = []
    validate!
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

  protected

  def validate!
    raise "Неверно указано название станции!" if @name !~ NUMBER_FORMAT
    true
  end
end
