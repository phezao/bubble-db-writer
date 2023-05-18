# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../../../lib/bubble_ruby'

RSpec.describe BubbleRuby::DB::Schema::Tables::Response do
  describe '#new' do
    context 'when data has the correct json response' do
      it 'assigns table_names and tables_response' do
        data = { 'definitions' => { 'Ratings' => 'something' }, 'paths' => { '/obj/Ratings/{UniqueID}' => 'test' } }
        expect { BubbleRuby::DB::Schema::Tables::Response.new(data.to_json) }.not_to raise_error
      end
    end

    context "when the data doesn't have the correct json response" do
      it 'raises an error' do
        expect { BubbleRuby::DB::Schema::Tables::Response.new('{}') }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#table_names' do
    it 'returns an array of all the names of the tables' do
      data = { 'definitions' => { 'Ratings' => 'something' }, 'paths' => { '/obj/Ratings/{UniqueID}' => 'test' } }
      response = BubbleRuby::DB::Schema::Tables::Response.new(data.to_json)

      expect(response.table_names).to eq(['Ratings'])
    end
  end

  describe '#tables_response' do
    xit 'returns the entire response of the tables' do
    end
  end
end
