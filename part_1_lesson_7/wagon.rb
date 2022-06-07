require_relative 'manufacturer_name'
require_relative 'validation'

class Wagon
  include ManufacturerName
  include Validation

  NUMBER_FORMAT = /^\S/

  attr_reader :number, :type

  def initialize(number)
    @number = number
    validate!
  end

  protected

  def validate!
    raise "Неверно указан номер поезда!" if @number !~ NUMBER_FORMAT
    true
  end
end
