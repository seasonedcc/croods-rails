# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Croods::Resource, type: :model do
  let(:resource) { 'Foos' }

  before do
    stub_const("#{resource}::Resource", Class.new { include Croods::Resource })
  end

  describe '.create_model!' do
    context 'with no resources' do
      it { expect { Foo }.to raise_error(NameError) }
      it { expect { Bar }.to raise_error(NameError) }
    end

    context 'with Foos resource' do
      before do
        Foos::Resource.create_model!
      end

      it { expect { Foo }.not_to raise_error(NameError) }
    end

    context 'with Bars resource' do
      let(:resource) { 'Bars' }

      before do
        Bars::Resource.create_model!
      end

      it { expect { Bar }.not_to raise_error(NameError) }
    end
  end

  describe '.create_controller!' do
    context 'with no resources' do
      it { expect { FoosController }.to raise_error(NameError) }
      it { expect { BarsController }.to raise_error(NameError) }
    end

    context 'with Foos resource' do
      before do
        Foos::Resource.create_controller!
      end

      it { expect { FoosController }.not_to raise_error(NameError) }
    end

    context 'with Bars resource' do
      let(:resource) { 'Bars' }

      before do
        Bars::Resource.create_controller!
      end

      it { expect { BarsController }.not_to raise_error(NameError) }
    end
  end
end
