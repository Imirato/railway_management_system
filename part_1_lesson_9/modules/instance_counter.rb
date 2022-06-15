# frozen_string_literal: true

module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    attr_reader :instances

    private

    attr_writer :instances
  end

  module InstanceMethods
    private

    def register_instance
      self.class.class_eval do
        self.instances = (instances.nil? ? 1 : instances + 1)
      end
    end
  end
end
