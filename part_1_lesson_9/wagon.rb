# frozen_string_literal: true

require_relative 'modules/manufacturer_name'
require_relative 'modules/validation'

class Wagon
  include ManufacturerName
  include Validation

  NUMBER_FORMAT = /^\S/.freeze

  attr_reader :number, :type

  def initialize(number)
    @number = number
    validate!
  end

  protected

  def validate!
    raise 'Неверно указан номер поезда!' if @number !~ NUMBER_FORMAT

    true
  end
end
