# frozen_string_literal: true

require_relative './../db_table_writer'

RSpec.describe DbTableWriter do
  describe '#call' do
    context 'when iterating on each table' do
      it 'generates and executes an SQL query to create a table in postgres' do
        schema = [{ name: 'Company', body: { name: 'TEXT' } }]
        pg_instance = double
        allow(pg_instance).to receive(:exec)
        queries = described_class.new(schema, pg_instance).call.first
        query_expected = <<~SQL
          CREATE TABLE "Company" (
            id uuid DEFAULT gen_random_uuid () PRIMARY KEY,
            "name" TEXT
          );
        SQL

        expect(queries.split).to eq(query_expected.split)
      end
    end
  end
end
