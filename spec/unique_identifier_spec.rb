require 'spec_helper'

describe UniqueIdentifier do
  describe ".unique_identifier" do

    context "callbacks" do

      context "when unique_id attribute +is not+ validated" do
        before do
          DummyModel = build_dummy_class(
            :number,
            Proc.new { "R#{Array.new(9) { rand(9) }.join}" }
          )
        end

        let(:model) { DummyModel.create }

        it "populates the specified field on create" do
          expect(model.number).to match(/R\d{9}/)
        end
      end

      context "when unique_id attribute +is+ validated" do
        before do
          DummyModel = build_dummy_class(
            :number,
            Proc.new { "R#{Array.new(9) { rand(9) }.join}" },
            validate: true
          )
        end

        let(:model) { DummyModel.create }

        it "populates the specified field before any validations, on create" do
          expect(model.number).to match(/R\d{9}/)
        end

        it "creates a valid instance" do
          expect(model.valid?).to be_truthy
          expect(model.errors).to be_empty
        end

      end

    end

    context "uniqueness" do

      before do
        i = -1
        DummyModel = build_dummy_class(:number, Proc.new { i += 1 })
        class InheritedModel < DummyModel
          x = -1
          unique_id :number, Proc.new { x += 1 }
        end
        class FurtherInheritedModel < InheritedModel
          j = -1
          unique_id :number, Proc.new { j += 1 }
        end
      end

      let!(:model)                   { DummyModel.create }
      let!(:inherited_model)         { InheritedModel.create }
      let!(:further_inherited_model) { FurtherInheritedModel.create }

      it "creates only truely unique fields" do
        expect(model.number).to eq("0")
        expect(inherited_model.number).to eq("1")
        expect(further_inherited_model.number).to eq("2")
      end

    end

  end
end
