require 'unique_identifier/matchers/have_unique_id_matcher'

module UniqueIdentifier
  module Shoulda
    #
    # NOTE: borrowing heavily here from Paperclip,
    # e.g. HaveAttachedFileMatcher
    #
    # In spec_helper.rb, you'll need to require the matchers:
    #
    #   require "unique_identifier/matchers"
    #
    # And _include_ the module:
    #
    #   RSpec.configure do |config|
    #     config.include UniqueIdentifier::Shoulda::Matchers
    #   end
    #
    # Example:
    #   describe Order do
    #     it { should have_unique_id(:number) }
    #   end
    module Matchers
    end
  end
end
