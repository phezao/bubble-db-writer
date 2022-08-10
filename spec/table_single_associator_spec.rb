# frozen_string_literal: true

require_relative './../table_single_associator'

RSpec.describe TableSingleAssociator do
  describe '#call' do
    context 'when the record from the table in the iteration has a bubble_id' do
      it 'generates an SQL query to add foreign key to the table' do
        table_name = ['Company Service 2.0']
        bubble_api_service = double
        allow(bubble_api_service).to receive(:call).and_return([{ Company: '1625820859739x819175157748203500' }])
        pg_service = double
        allow(pg_service).to receive(:exec)
        table_single_associator = described_class.new(bubble_api_service, table_name, pg_service).call.first
        query_expected = <<-SQL
          ALTER TABLE "Company Service 2.0" ADD COLUMN company_id INT
          REFERENCES "Company";
        SQL
        expect(table_single_associator.split).to eq(query_expected.split)
      end
    end
  end
end
