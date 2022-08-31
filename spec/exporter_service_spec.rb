# frozen_string_literal: true

require_relative './../exporter_service'

RSpec.describe ExporterService do
  describe '#write' do
    let(:data) { { "test": 'hello world' } }
    it 'exports a file' do
      exporter = described_class.new

      exporter.write('test', data)
      expect(File.exist?('test.rb')).to be_truthy
      expect(File.exist?('test.json')).to be_truthy
    end
  end
end
