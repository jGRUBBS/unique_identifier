require 'bundler/setup'
Bundler.setup

require 'rails'
require 'active_record'
require 'unique_identifier'

UniqueIdentifier::Railtie.insert

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")

RSpec.configure do |config|

  config.before(:all) do
    m = ActiveRecord::Migration.new
    m.verbose = false
    m.create_table :dummy_models do |t|
      t.string :number
      t.string :type
    end
  end

  config.after(:all) do
    m = ActiveRecord::Migration.new
    m.verbose = false
    m.drop_table :dummy_models
  end

end


def build_dummy_class(unique_attr_name = nil, unique_options = {}, class_options = {})
  # setup class and include unique_identifier
  klass = build_dummy_base_class

  klass.class_eval do
    unique_id unique_attr_name, unique_options

    if class_options.fetch(:validate, false)
      validates unique_attr_name, presence: true
    end
  end

  klass
end

def build_dummy_base_class
  class_name = "DummyModel"

  ActiveRecord::Base.send(:include, UniqueIdentifier::Glue)
  Object.send(:remove_const, class_name) rescue nil

  # Set class as a constant
  klass = Object.const_set(class_name, Class.new(ActiveRecord::Base))
  klass
end
