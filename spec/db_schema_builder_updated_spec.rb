require 'spec_helper'
require_relative './../db_schema_builder_updated'

RSpec.describe DbSchemaBuilderUpdated do
  let(:builder) { described_class.new }
  describe '#fetch' do
    it 'returns a parsed response of the swagger api' do
      expect(builder.fetch).to be_a(Hash)
    end
  end

  describe '#create_table_names' do
    it 'returns an array of hashes, containing the table names' do
      res = builder.fetch

      expect(builder.create_table_names(res)).to be_a(Array)
    end
  end
end
