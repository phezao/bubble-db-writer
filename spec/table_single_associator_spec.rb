# frozen_string_literal: true

require_relative './../table_single_associator'

RSpec.describe TableSingleAssociator do
  describe '#call' do
    context 'when the record from the table in the iteration has a bubble_id' do
      it 'generates an SQL query to add foreign key to the table'
    end
  end
end
