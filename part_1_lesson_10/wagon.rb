# frozen_string_literal: true

require_relative 'modules/manufacturer_name'
require_relative 'modules/validation'

class Wagon
  include ManufacturerName
  include Validation

  attr_reader :number, :type

  validate :number, :presence
  validate :number, :type, String

  def initialize(number)
    @number = number
    validate!
  end
end
