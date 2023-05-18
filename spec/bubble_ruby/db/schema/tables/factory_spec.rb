# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../../../lib/bubble_ruby'

RSpec.describe BubbleRuby::DB::Schema::Tables::Factory do
  describe '#new' do
    context 'when the argument is the Response type' do
      it 'returns an instance of Factory' do
        data = { 'definitions' => { 'Ratings' => 'something' }, 'paths' => { '/obj/Ratings/{UniqueID}' => 'test' } }
        response = BubbleRuby::DB::Schema::Tables::Response.new(data.to_json)
        expect { BubbleRuby::DB::Schema::Tables::Factory.new(response) }.not_to raise_error
      end
    end

    context 'when the argument is not the Response type' do
      it 'raises a TypeError' do
        expect { BubbleRuby::DB::Schema::Tables::Factory.new(Object.new) }.to raise_error(TypeError)
      end
    end
  end

  describe '#call' do
    it 'returns an array of Table objects' do
      table_response = { 'Ratings' => { 'properties' => { 'value' => { 'type' => 'number' } } } }
      response = spy
      allow(response).to receive(:is_a?).and_return(BubbleRuby::DB::Schema::Tables::Response)
      allow(response).to receive(:tables_response).and_return(table_response)
      factory = BubbleRuby::DB::Schema::Tables::Factory.new(response)

      tables = factory.call

      expect(tables).to be_a(Array)
      expect(tables).to all be_a(BubbleRuby::DB::Schema::Table)
    end
  end
end
