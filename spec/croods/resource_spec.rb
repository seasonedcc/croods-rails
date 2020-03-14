# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Croods::Resource, type: :model do
  before do
    stub_const("#{resource}::Resource", Class.new(described_class))
  end

  context 'with Foos resource' do
    let(:resource) { 'Foos' }

    context 'without initializing' do
      it { expect { Foo }.to raise_error(NameError) }
    end

    context 'with initializing' do
      before do
        Foos::Resource.new
      end

      it { expect { Foo }.not_to raise_error(NameError) }
    end
  end

  context 'with Bars resource' do
    let(:resource) { 'Bars' }

    context 'without initializing' do
      it { expect { Bar }.to raise_error(NameError) }
    end

    context 'with initializing' do
      before do
        Bars::Resource.new
      end

      it { expect { Bar }.not_to raise_error(NameError) }
    end
  end
end
