# frozen_string_literal: true

module Validation
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    def validations
      @validations ||= []
    end

    def validate(name, type_validation, optional_parameter = nil)
      validation = { name: name, type_validation: type_validation, optional_parameter: optional_parameter }
      instance_variable_set(:@validations, validations.push(validation))
    end
  end

  module InstanceMethods
    def validate!
      self.class.validations.each { |i| verification(i) }
    end

    def verification(validation)
      name, type_validation, optional_parameter = validation.values
      value = instance_variable_get("@#{name}".to_sym)

      case type_validation
      when :presence
        raise ArgumentError, 'Номер/название не может быть пустым!' if value.nil? || value.to_s.empty?
      when :format
        raise ArgumentError, 'Номер/название не соответствует формату!' unless value =~ optional_parameter
      when :type
        raise TypeError, 'Неверный тип!' unless value.is_a?(optional_parameter)
      end
    end

    def valid?
      validate!
      true
    rescue ArgumentError, TypeError
      false
    end
  end
end
