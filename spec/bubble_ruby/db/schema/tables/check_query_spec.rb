# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../../../lib/bubble_ruby'
require_relative '../../../../support/query_helper'

RSpec.describe BubbleRuby::DB::Schema::Tables::CheckQuery do
  describe '.call' do
    it 'returns an SQL query to check all the tables' do
      result =
        <<-SQL
          SELECT table_name FROM information_schema.tables
          WHERE table_schema = 'public'
          ORDER BY table_name;
        SQL

      query = BubbleRuby::DB::Schema::Tables::CheckQuery.call

      expect(QueryHelper::RemoveSpaces[query]).to eq(QueryHelper::RemoveSpaces[result])
    end
  end
end
