# frozen_string_literal: true

require_relative './../bubble_api_service'

RSpec.describe BubbleApiService do
  describe '#call' do
    context 'with two arguments ("Shift", 5)' do
      it 'returns an array of data with length of 5' do
        expect(subject.call('Shift', 5)['results'].length).to eq(5)
      end
    end

    context 'with only one argument/name ("Shift")' do
      it 'returns an array of a single data point' do
        expect(subject.call('Shift')['results'].length).to eq(1)
      end
    end

    context 'without any arguments' do
      it 'should raise an error' do
        expect { subject.call }.to raise_error(ArgumentError)
      end
    end
  end
end
