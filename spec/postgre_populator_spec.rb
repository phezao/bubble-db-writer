# frozen_string_literal: true

require_relative './../postgre_populator'

RSpec.describe PostgrePopulator do
  describe '#call' do
    it 'returns an array of queries' do
      bubble_api_service = double
      array_of_queries = described_class.new(bubble_api_service).call('Ratings')
      query = <<-SQL
      INSERT INTO table (column1, column2, column3)
      VALUES (value1, value2, value3);
      SQL
      expect(array_of_queries.first.split).to eq(query.split)
    end
  end
end
