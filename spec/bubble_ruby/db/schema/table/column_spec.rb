# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../../../lib/bubble_ruby'

RSpec.describe BubbleRuby::DB::Schema::Table::Column do
  describe '#new' do
    it 'returns a new instance of Table::Column with table name, column name and column type' do
      table_column = BubbleRuby::DB::Schema::Table::Column.new(
        table_name: 'Ratings',
        name: 'value',
        type: { 'type' => 'number' }
      )

      expect(table_column).to be_a(BubbleRuby::DB::Schema::Table::Column)
      expect(table_column.table_name).to eq('Ratings')
      expect(table_column.name).to eq('value')
      expect(table_column.type).to eq('FLOAT8')
    end
  end

  describe '#create_query' do
    it 'calls the CreateQuery' do
      table_column = BubbleRuby::DB::Schema::Table::Column.new(
        table_name: 'Ratings',
        name: 'value',
        type: { 'type' => 'number' }
      )

      expect(table_column.create_query).to be_a(String)
    end
  end
end
