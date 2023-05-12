# require 'bubble_ruby/schema_refiner'
# require 'byebug'

# module BubbleRuby
#   RSpec.describe SchemaRefiner do
#     describe '#call' do
#       let(:schema) { double }
#       let(:refiner) { described_class.new(schema) }

#       describe '#verify_table_columns' do
#         context "when the column doesn't exist in the pg_columns schema" do
#           it 'adds the column to the pg_schema' do
#             table = { name: 'shift',
#                       body: { 'Created Date' => 'TIMESTAMPTZ', 'Company' => 'TEXT', 'bubble_id' => 'TEXT' } }
#             allow(refiner).to receive(:build_check_column_names_query)
#             allow(refiner).to receive(:execute_query).and_return(schema)
#             allow(schema).to receive(:column_values).and_return(['Created Date'])
#             allow(refiner).to receive(:add_column).and_return('column added')

#             expect(refiner).to receive(:add_column).exactly(2).times

#             refiner.send(:verify_table_columns, table)
#           end
#         end

#         context 'when the column already exists in the pg_columns schema' do
#           it 'goes to the next column' do
#             table = { name: 'shift',
#                       body: { 'Created Date' => 'TIMESTAMPTZ', 'Company' => 'TEXT', 'bubble_id' => 'TEXT' } }
#             allow(refiner).to receive(:build_check_column_names_query)
#             allow(refiner).to receive(:execute_query).and_return(schema)
#             allow(schema).to receive(:column_values).and_return(['Created Date', 'Company', 'bubble_id'])
#             allow(refiner).to receive(:add_column).and_return('column added')

#             expect(refiner).not_to receive(:add_column)

#             refiner.send(:verify_table_columns, table)
#           end
#         end
#       end

#       describe '#build_check_column_names_query' do
#         it 'returns the query to see all the columns from a given table' do
#           query = refiner.send(:build_check_column_names_query, 'shift')
#           expected_query = <<-SQL
#         SELECT * FROM information_schema.columns
#         WHERE table_schema = 'public'
#         AND table_name = 'shift'
#           SQL

#           expect(query.split).to eq(expected_query.split)
#         end
#       end

#       context 'when the table name already exists inside the pg_schema' do
#         it 'executes #verify_table_columns' do
#           table = { name: 'shift',
#                     body: { 'Created Date' => 'TIMESTAMPTZ', 'Company' => 'TEXT', 'bubble_id' => 'TEXT' } }
#           schema = [table]
#           response = double
#           refiner = described_class.new(schema)
#           allow(refiner).to receive(:build_check_column_names_query)
#           allow(refiner).to receive(:execute_query).and_return(response)
#           allow(response).to receive(:column_values).and_return(['shift'])
#           allow(refiner).to receive(:verify_table_columns).and_return('executed')

#           expect(refiner).to receive(:verify_table_columns).once
#           refiner.call
#         end
#       end

#       context "when the table name doesn't exists in the pg_schema" do
#         it 'executes the #create_table' do
#           table = { name: 'shift',
#                     body: { 'Created Date' => 'TIMESTAMPTZ', 'Company' => 'TEXT', 'bubble_id' => 'TEXT' } }
#           schema = [table]
#           response = double
#           refiner = described_class.new(schema)
#           allow(refiner).to receive(:build_check_column_names_query)
#           allow(refiner).to receive(:execute_query).and_return(response)
#           allow(response).to receive(:column_values).and_return(['company'])
#           allow(refiner).to receive(:create_table).and_return('executed')

#           expect(refiner).to receive(:create_table).once
#           refiner.call
#         end
#       end
#     end
#   end
# end
