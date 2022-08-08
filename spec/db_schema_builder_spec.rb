# frozen_string_literal: true

require_relative './../db_schema_builder'
require_relative './../tables_name_source'

RSpec.describe DbSchemaBuilder do
  describe '.new' do
    context '#schema' do
      subject { described_class.new.schema }
      it { is_expected.to be_empty }
    end
  end

  describe '#table_names' do
    subject { described_class.new.table_names }

    it { is_expected.to eql(TABLE_NAMES) }
  end

  describe '#call' do
    subject { described_class.new.call }
    it { is_expected.to be_a(described_class) }
    describe '#schema' do
      subject { described_class.new.call.schema }
      it { is_expected.not_to be_empty }
    end

    it 'generates a schema file' do
      expect(File.exist?('schema.rb')).to be_truthy
    end
  end
end
