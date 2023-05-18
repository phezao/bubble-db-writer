# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../../../lib/bubble_ruby'
require_relative '../../../../support/query_helper'

RSpec.describe BubbleRuby::DB::Schema::Table::CreateQuery do
  describe '.call' do
    context 'when a table object is passed' do
      it 'returns an SQL query to create the columns of the table' do
        table = BubbleRuby::DB::Schema::Table.new(name: 'Ratings')
        table_column = BubbleRuby::DB::Schema::Table::Column.new(
          table_name: 'Ratings',
          name: 'value',
          type: { 'type' => 'number' }
        )
        table.body << table_column

        result =
          "
            CREATE TABLE \"Ratings\" (
              id uuid DEFAULT gen_random_uuid () PRIMARY KEY, \"value\" FLOAT8
            );
          "

        test = BubbleRuby::DB::Schema::Table::CreateQuery.call(table)

        expect(QueryHelper::RemoveSpaces[test]).to eq(QueryHelper::RemoveSpaces[result])
      end
    end

    context 'when another object is passed' do
      it 'raises a TypeError' do
        expect { BubbleRuby::DB::Schema::Table::CreateQuery.call(Object) }.to raise_error(TypeError)
      end
    end
  end
end
