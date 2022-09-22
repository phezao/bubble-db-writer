# frozen_string_literal: true

require 'legacy/schema_refiner'
require 'bubble_ruby/bubble_api_service'

RSpec.describe SchemaRefiner do
  let(:table_names) { %w[Ratings ServiceSource] }
  before do
    bubble_api_service = BubbleRuby::BubbleApiService.new
    pg_service = double
    schema = SCHEMA
    @schema_refiner = described_class.new(table_names, bubble_api_service, pg_service, schema)
  end
  describe '#call' do
    xit 'returns 50 records of each table'

    xit 'compares each records columns with the actual schema'
  end

  describe '#fetch' do
    context 'with a table_name' do
      xit 'returns 50 records of that table' do
        response = @schema_refiner.fetch(table_names.first)
        expect(response.size).to eq(50)
      end
    end
  end

  describe '#find_schema' do
    xit 'returns the schema hash of the table_name' do
      schema = @schema_refiner.find_schema(table_names.first)
      expect(schema).to be_a(Hash)
    end
  end

  describe '#build_query' do
    xit 'builds the query to add column to the table' do
      query = @schema_refiner.build_query('Ratings', 'OldNurse', '1653302113315x870841398345215900')
      expected_query = <<-SQL
      ALTER TABLE "Ratings"
      ADD COLUMN "OldNurse" TEXT;
      SQL
      expect(query.split).to eq(expected_query.split)
    end
  end

  describe '#compare_record' do
    xit 'evaluates if the table should include new fields or not' do
      schema = @schema_refiner.find_schema(table_names.first)
      record = { 'Rating' => 0.5, 'OldNurse' => '1620319213752x904771506412978200',
                 'Created By' => '1619568399540x516600605481364100', 'Created Date' => '2021-05-17T18:35:10.916Z', 'Modified Date' => '2021-05-17T18:35:10.960Z', '_id' => '1621276509740x195970108042510340' }
      queries = @schema_refiner.compare_record(record, schema, table_names.first)
      expect(queries.size).to eq(1)
    end
  end
end
