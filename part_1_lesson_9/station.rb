# frozen_string_literal: true

require_relative 'modules/instance_counter'
require_relative 'modules/validation'

class Station
  include InstanceCounter
  include Validation

  NUMBER_FORMAT = /^\S/.freeze

  attr_reader :trains_list, :name

  def initialize(name)
    @name = name
    @trains_list = []
    validate!
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

  def each_train(&block)
    @trains_list.each { |train| block.call(train) }
  end

  protected

  def validate!
    raise 'Неверно указано название станции!' if @name !~ NUMBER_FORMAT

    true
  end
end
