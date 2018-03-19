require "unique_identifier/version"
require "rails"

module UniqueIdentifier

  module ClassMethods

    mattr_accessor :field, :block, :klass

    def unique_id(field, block)
      const_set('UNIQUE_IDENTIFIER_FIELD', field)
      const_set('UNIQUE_IDENTIFIER_BLOCK', block)

      before_validation :generate_unique_id, on: :create
    end

  end

  module InstanceMethods
    def generate_unique_id
      klass       = self.class
      klass_field = klass.const_get('UNIQUE_IDENTIFIER_FIELD')
      klass_block = klass.const_get('UNIQUE_IDENTIFIER_BLOCK')
      return if self.send(klass_field)

      identifier = loop do
        random = klass_block.call
        unless klass.base_class.exists?(klass_field => random)
          break random
        end
      end
      self.send "#{klass_field}=", identifier
    end
  end


  module Glue
    def self.included(base)
      base.extend(ClassMethods)
      base.send :include, InstanceMethods
    end
  end

  if defined? Rails::Railtie

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
