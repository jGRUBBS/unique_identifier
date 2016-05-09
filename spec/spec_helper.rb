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


def build_class(name, options = {})
  # setup class and include delayed_cron

  class_name = "DummyModel"

  ActiveRecord::Base.send(:include, UniqueIdentifier::Glue)
  Object.send(:remove_const, class_name) rescue nil

  # Set class as a constant
  klass = Object.const_set(class_name, Class.new(ActiveRecord::Base))

  klass.class_eval do

    unique_id name, options

  end

  klass
end
