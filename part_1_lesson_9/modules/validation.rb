# frozen_string_literal: true

module Validation
  def valid?
    validate!
  rescue RuntimeError
    false
  end
end
