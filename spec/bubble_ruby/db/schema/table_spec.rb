# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../../lib/bubble_ruby'

RSpec.describe BubbleRuby::DB::Schema::Table do
  describe '#create_query' do
    it 'calls the CreateQuery module' do
      table = BubbleRuby::DB::Schema::Table.new(name: 'Ratings')
      table_column = BubbleRuby::DB::Schema::Table::Column.new(
        table_name: table.name,
        name: 'value',
        type: { 'type' => 'number' }
      )
      table.body << table_column

      expect(BubbleRuby::DB::Schema::Table::CreateQuery).to receive(:call).with(table)
      table.create_query
    end
  end
end
