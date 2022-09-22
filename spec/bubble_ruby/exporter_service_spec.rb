# frozen_string_literal: true

require 'bubble_ruby/exporter_service'

module BubbleRuby
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
end
