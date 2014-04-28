require "unique_identifier/version"

module UniqueIdentifier

  module ClassMethods

    mattr_accessor :field, :block, :klass
  
    def unique_id(field, block)
      @klass = self.name.constantize
      @klass.const_set('BLOCK', block)
      @klass.const_set('FIELD', field)
      @klass.set_callback(:create, :before, :generate_unique_id)
    end
  
  end

  module InstanceMethods
    def generate_unique_id
      return if self.send(self.class::FIELD)
      identifier = loop do
        random = self.class::BLOCK.call
        break random unless self.class.exists?(self.class::FIELD => random)
      end
      self.send "#{self.class::FIELD}=", identifier
    end
  end


  module Glue
    def self.included(base)
      base.extend(ClassMethods)
      base.send :include, InstanceMethods
    end
  end

  if defined? Rails::Railtie
    require 'rails'

    class Railtie < Rails::Railtie
      initializer 'unique_identifier.insert_into_active_record' do
        ActiveSupport.on_load :active_record do
          UniqueIdentifier::Railtie.insert
        end
      end
    end
  end

  class Railtie

    def self.insert
      ActiveRecord::Base.send(:include, UniqueIdentifier::Glue)
    end

  end

end
