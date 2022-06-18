# frozen_string_literal: true

module Accessors
  def attr_accessor_with_history(*values)
    values.each do |value|
      value_name = "@#{value}".to_sym
      value_history = "@#{value}_history".to_sym
      define_method(value) { instance_variable_get(value_name) }
      define_method("#{value}_history".to_sym) { instance_variable_get(value_history) }
      define_method("#{value}=".to_sym) do |val|
        instance_variable_set(value_name, val)
        instance_variable_set(value_history, (instance_variable_get(value_history) || []).push(val))
      end
    end
  end

  def strong_attr_accessor(value, value_class)
    value_name = "@#{value}".to_sym
    define_method(value) { instance_variable_get(value_name) }
    define_method("#{value}=".to_sym) do |val|
      raise 'Тип не соответствует' unless val.is_a?(value_class)

      instance_variable_set(value_name, val)
    end
  end
end
