require_relative 'manufacturer_name'

class Wagon
  include ManufacturerName

  attr_reader :number, :type

  def initialize(number)
    @number = number
  end
end
