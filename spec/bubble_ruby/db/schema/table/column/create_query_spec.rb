# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../../../../lib/bubble_ruby'

RSpec.describe 'BubbleRuby::DB::Schema::Table::Column::CreateQuery' do
  describe '.call' do
    context 'when a table_column object is passed' do
      it 'returns an SQL query to create the columns of the table' do
        params = { 'type' => 'number' }
        table_column = BubbleRuby::DB::Schema::Table::Column.new(
          table_name: 'Ratings',
          name: 'value',
          type: params
        )

        result =
          <<-SQL
            ALTER TABLE \"Ratings\"
            ADD COLUMN \"value\" FLOAT8;
          SQL

        expect(BubbleRuby::DB::Schema::Table::Column::CreateQuery.call(table_column)).to eq(result)
      end
    end

    context 'when another object is passed' do
      it 'raises a TypeError' do
        expect { BubbleRuby::DB::Schema::Table::Column::CreateQuery.call(Object) }.to raise_error(TypeError)
      end
    end
  end
end
