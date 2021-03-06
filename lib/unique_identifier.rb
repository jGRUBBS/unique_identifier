require "unique_identifier/version"
require "rails"

module UniqueIdentifier

  module ClassMethods

    mattr_accessor :field, :block, :klass

    def unique_id(field, block)
      const_set('BLOCK', block)
      const_set('FIELD', field)
      before_validation :generate_unique_id, on: :create
    end

  end

  module InstanceMethods
    def generate_unique_id
      return if self.send(self.class::FIELD)
      identifier = loop do
        random = self.class::BLOCK.call
        unless self.class.base_class.exists?(self.class::FIELD => random)
          break random
        end
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
