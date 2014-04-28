require 'spec_helper'

describe UniqueIdentifier do

  describe "unique_identifier" do
    
    it "should" do
      DummyModel = build_class( :number, Proc.new { "#{DummyModel::MODE}#{Array.new(9) { rand(9) }.join}" } )
      model1 = DummyModel.create
      model1.number.should_not be_nil
    end

  end

end