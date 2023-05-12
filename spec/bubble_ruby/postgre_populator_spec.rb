# # frozen_string_literal: true

# require 'bubble_ruby/postgre_populator'
# require 'bubble_ruby/bubble_api_service'
# require 'byebug'

# module BubbleRuby
#   RSpec.describe PostgrePopulator do
#     describe '#call' do
#       let(:bubble_api_service) { double }
#       let(:populator) { described_class.new(bubble_api_service) }
#       describe '#fetch_last_record_from_db' do
#         it 'returns the last record in the postgre db from the table' do
#           populator = described_class.new(bubble_api_service)

#           res = populator.send(:fetch_last_record_from_db, 'shift')
#           date = DateTime.parse(res['Created Date'])

#           expect(date).to be > DateTime.new(2022, 0o7, 30)
#         end
#       end
#       describe '#write_entries' do
#         let(:response) do
#           { 'results' => [{ 'Created Date' => '2022-09-23T16:16:12.360Z', '_id' => '1662394570774x102008655749389380' }],
#             'remaining' => 23 }
#         end
#         context 'when the bubble_record id matches the record id' do
#           it 'returns 0' do
#             allow(populator).to receive(:fetch_records_from_bubble).and_return(response)
#             db_record = { 'bubble_id' => '1662394570774x102008655749389380',
#                           'Created Date' => '2022-09-23T16:16:12.360Z' }
#             expect(populator.send(:write_entries, 'Company', db_record)).to eq(0)
#           end
#         end

#         context "when the bubble_record id doesn't match the record id" do
#           it 'returns the remaining number of entries' do
#             allow(bubble_api_service).to receive(:fetch_records).and_return(response)
#             db_record = { 'bubble_id' => '1662394570774x102008455749389380',
#                           'Created Date' => '2022-08-30T16:16:12.360Z' }
#             allow(populator).to receive(:populate_db).and_return('test')
#             expect(populator.send(:write_entries, 'Company', db_record)).to eq(23)
#           end
#         end
#       end

#       describe '#fetch_records_from_bubble' do
#         it 'returns the 100 last records from bubble' do
#           bubble_api_service = BubbleRuby::BubbleApiService.new
#           populator = described_class.new(bubble_api_service)
#           res = populator.send(:fetch_records_from_bubble, 'Shift', 0)

#           expect(res['results'].length).to eq(100)
#         end
#       end

#       describe '#populate_db' do
#         it 'builds and executes the query' do
#           bubble_record = { '_id' => '1662394570774x102008655749385870', 'Created Date' => '2022-09-05T16:16:12.360Z' }
#           allow(populator).to receive(:build_insert_data_query).and_return('build query')
#           allow(populator).to receive(:execute_query).and_return('query executed')
#           res = populator.send(:populate_db, bubble_record, 'Company')

#           expect(res).not_to be_nil
#         end
#       end

#       describe '#build_insert_data_query' do
#         it 'returns the postgresql query to insert data into the db' do
#           record = { 'Created Date' => '2022-08-30T16:16:12.360Z', '_id' => '1662394570774x102008655749389380' }
#           res = populator.send(:build_insert_data_query, 'Company', record)

#           query = <<-SQL
#         INSERT INTO "Company" ("Created Date", "bubble_id")
#         VALUES ('2022-08-30T16:16:12.360Z', '1662394570774x102008655749389380')
#           SQL
#           expect(res.split).to eq(query.split)
#         end
#       end

#       describe '#rename_id_to_bubble_id' do
#         it 'substitutes the _id to bubble_id in the record.keys' do
#           record = { 'Created Date' => '2022-08-30T16:16:12.360Z', '_id' => '1662394570774x102008655749389380' }
#           res = populator.send(:rename_id_to_bubble_id, record.keys)

#           expect(res).not_to include('_id')
#           expect(res).to include('"bubble_id"')
#         end
#       end

#       describe '#check_data_type_and_return_formatted_value' do
#         context 'when the value is an integer, a boolean or a float' do
#           it 'returns the normal value' do
#             expect(populator.send(:check_data_type_and_return_formatted_value, 20)).to eq(20)
#             expect(populator.send(:check_data_type_and_return_formatted_value, false)).to eq(false)
#             expect(populator.send(:check_data_type_and_return_formatted_value, 3.5)).to eq(3.5)
#           end
#         end
#         context 'when the value is an array' do
#           it 'returns a string of a postgres array (using the {}) separated by commas' do
#             expect(populator.send(:check_data_type_and_return_formatted_value, [20, 30])).to eq("'{20, 30}'")
#           end
#         end
#         context 'when the value is a hash or nil' do
#           it 'returns a json string' do
#             expect(populator.send(:check_data_type_and_return_formatted_value,
#                                   { 'address' => 'Rua abc',
#                                     'number' => '239' })).to eq("'{\"address\":\"Rua abc\",\"number\":\"239\"}'")
#           end
#         end
#         context 'when the value is a date' do
#           it 'returns the date as a string' do
#             expect(populator.send(:check_data_type_and_return_formatted_value,
#                                   '2022-08-30T16:16:12.360Z')).to eq("'2022-08-30T16:16:12.360Z'")
#           end
#         end

#         context 'when the value is a bubble_id or a string' do
#           it 'returns the string without single quote and double quotes becomes asterisks' do
#             expect(populator.send(:check_data_type_and_return_formatted_value,
#                                   '1662394570774x102008655749389380')).to eq("'1662394570774x102008655749389380'")
#             expect(populator.send(:check_data_type_and_return_formatted_value,
#                                   'This is the so called "double" quotes')).to eq("'This is the so called %double% quotes'")
#             expect(populator.send(:check_data_type_and_return_formatted_value,
#                                   "This ain't going to be easy")).to eq("'This ain t going to be easy'")
#           end
#         end
#       end
#     end
#   end
# end
