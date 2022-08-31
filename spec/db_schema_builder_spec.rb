# frozen_string_literal: true

require_relative './../db_schema_builder'

RSpec.describe DbSchemaBuilder do
  let(:db_schema_builder) { described_class.new(double, ['Nurse']) }
  describe '.new' do
    context '#schema' do
      it 'returns an empty array' do
        expect(db_schema_builder.schema).to be_empty
      end
    end

    describe '#call' do
      it 'returns an instance of itself' do
        expect(db_schema_builder.call).to be_a(described_class)
      end
    end
  end
end
