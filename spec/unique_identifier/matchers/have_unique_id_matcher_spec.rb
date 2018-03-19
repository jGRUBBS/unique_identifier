require 'spec_helper'
require 'unique_identifier/matchers'

describe UniqueIdentifier::Shoulda::Matchers::HaveUniqueIdMatcher do
  extend UniqueIdentifier::Shoulda::Matchers
  let(:matcher) { self.class.have_unique_id(:number) }

  it "rejects the dummy class if it does not call `unique_id` for the column" do
    DummyModel = build_dummy_base_class
    expect(matcher.matches?(DummyModel)).to be_falsy
  end

  it "rejects the dummy class if the block does not return a unique string" do
    DummyModel = build_dummy_class(:number, Proc.new { "R1111111" })
    expect(matcher.matches?(DummyModel)).to be_falsy
  end

  it 'accepts the dummy class if it does call `unique_id` for the column' do
    DummyModel = build_dummy_class(:number, basic_random_proc)
    expect(matcher.matches?(DummyModel)).to be_truthy
  end
end
