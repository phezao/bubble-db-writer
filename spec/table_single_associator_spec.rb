# frozen_string_literal: true

require_relative './../table_single_associator'
require_relative './../bubble_api_service'

RSpec.describe TableSingleAssociator do
  let(:table_single_associator) { described_class.new(bubble_api_service, table_names, pg_service) }
  let(:bubble_api_service) { double }
  let(:table_names) { double }
  let(:pg_service) { double }

  describe '#get_string_columns' do
    let(:bubble_api_service) { BubbleApiService.new }
    let(:table_names) { ['Company Service 2.0'] }

    context 'when the record exists' do
      it 'returns a Hash of the columns that are string' do
        expect(table_single_associator.get_string_columns('Company Service 2.0')).to be_a(Hash)
      end

      it 'returns a hash with string columns' do
        expect(table_single_associator.get_string_columns('Company Service 2.0')).not_to be_empty
      end
    end

    context "when there's no record" do
      let(:table_names) { ['Features'] }
      it 'returns nil' do
        expect(table_single_associator.get_string_columns('Features')).to be_nil
      end
    end
  end

  describe '#bubble_id_matcher' do
    it 'checks if each records has a bubble_id' do
      allow(table_single_associator).to receive(:insert_foreign_key).and_return('foreign key inserted!')

      record = { Shift: '1625820859739x819175157748203500', "Created By": '1625078559739x819175157748203500',
                 "_id": '1625820859739x819175157748209670' }.transform_keys!(&:to_s)

      array = table_single_associator.bubble_id_matcher('ShiftCandidate', record).compact

      expect(array.length).to eq(1)
    end
  end

  describe '#insert_foreign_key' do
    it 'add the query to the queries instance variable' do
      allow(pg_service).to receive(:exec).and_return(true)
      table_single_associator.insert_foreign_key('ShiftCandidate', 'Shift')
      expect(table_single_associator.queries).not_to be_empty
    end

    it 'executes the query' do
      allow(pg_service).to receive(:exec).and_return(true)
      expect(table_single_associator.insert_foreign_key('ShiftCandidate', 'Shift')).to eq(true)
    end
  end

  describe '#build_query' do
    it 'returns a SQL query to add foreign key to the table and column given' do
      query = table_single_associator.build_query('ShiftCandidate', 'Shift')

      final_query = <<-SQL
      ALTER TABLE "ShiftCandidate" ADD COLUMN "shift_id" uuid
      REFERENCES "Shift";
      SQL

      expect(query.split).to eq(final_query.split)
    end
  end

  describe '#call' do
    let(:bubble_api_service) { BubbleApiService.new }
    context 'when the record from the table in the iteration has a bubble_id' do
      it 'generates an SQL query to add foreign key to the table' do
        table_name = ['Company Service 2.0']
        allow(pg_service).to receive(:exec)
        table_single_associator = described_class.new(bubble_api_service, table_name, pg_service).call.first
        query_expected = <<-SQL
          ALTER TABLE "Company Service 2.0" ADD COLUMN "company_id" uuid
          REFERENCES "Company";
        SQL

        expect(table_single_associator.split).to eq(query_expected.split)
      end
    end

    context "when the record from the table in the iteration doesn't have a bubble_id" do
      it 'skips the record and the table' do
        table_name = ['Features']
        allow(pg_service).to receive(:exec)
        table_single_associator = described_class.new(bubble_api_service, table_name, pg_service).call

        expect(table_single_associator).to eq([])
      end
    end
  end
end
