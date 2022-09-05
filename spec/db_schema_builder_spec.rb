# frozen_string_literal: true

require_relative './../db_schema_builder'

RSpec.describe DbSchemaBuilder do
  let(:bubble_table_fetcher) { double }
  let(:db_schema_builder) { described_class.new(bubble_table_fetcher, ['Nurse']) }
  describe '.new' do
    context '#schema' do
      it 'returns an empty array' do
        expect(db_schema_builder.schema).to be_empty
      end
    end
  end

  describe '#build_schema' do
    it 'creates a hash of the table data with name and body attributes' do
      allow(bubble_table_fetcher).to receive(:call).and_return({ name: 'TEXT' })
      db_schema_builder.send(:build_schema, 'Nurse')

      expected_schema = { name: 'Nurse', body: { name: 'TEXT' } }

      expect(db_schema_builder.schema.first).to eq(expected_schema)
    end
  end

  describe '#call' do
    it 'returns an array of the whole tables schema' do
      allow(bubble_table_fetcher).to receive(:call).and_return({ name: 'TEXT', phone: 'TEXT' })
      expected_schema = [{ name: 'Nurse', body: { name: 'TEXT', phone: 'TEXT' } }]

      expect(db_schema_builder.call).to eq(expected_schema)
    end
  end
end
