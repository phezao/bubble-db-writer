# require 'spec_helper'
# require 'bubble_ruby/db_schema_builder'

# module BubbleRuby
#   RSpec.describe DbSchemaBuilder do
#     let(:builder) { described_class.new }
#     describe '#fetch' do
#       it 'returns a parsed response of the swagger api' do
#         expect(builder.fetch).to be_a(Hash)
#       end
#     end

#     describe '#create_table_names' do
#       it 'returns an array of hashes, containing the table names' do
#         res = builder.fetch

#         table_names = builder.create_table_names(res)
#         p table_names
#         expect(table_names).to be_a(Array)
#       end
#     end

#     describe '#create_table_body' do
#       it 'returns the schema body' do
#         res = builder.fetch
#         builder.create_table_names(res)
#         builder.create_table_body(res)
#         allow(builder).to receive(:check_data_type_and_return_postgre_type).and_return('TEXT')

#         puts builder.schema
#         expect(builder.schema).to be_a(Array)
#       end
#     end
#   end
# end
