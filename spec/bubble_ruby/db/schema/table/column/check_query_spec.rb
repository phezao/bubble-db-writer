# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../../../../lib/bubble_ruby'

RSpec.describe 'BubbleRuby::DB::Schema::Table::Column::CheckQuery' do
  describe '.call' do
    context 'when a table object is passed' do
      it 'returns an SQL query to check the columns of the table' do
        table = BubbleRuby::DB::Schema::Table.new(name: 'Ratings')

        result =
          <<-SQL
            SELECT * FROM information_schema.columns
            WHERE table_schema = 'public'
            AND table_name = \'Ratings\'
          SQL

        expect(BubbleRuby::DB::Schema::Table::Column::CheckQuery.call(table)).to eq(result)
      end
    end

    context 'when another object is passed' do
      it 'raises a TypeError' do
        expect { BubbleRuby::DB::Schema::Table::Column::CheckQuery.call(Object) }.to raise_error(TypeError)
      end
    end
  end
end
