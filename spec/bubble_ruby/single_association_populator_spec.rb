# # frozen_string_literal: true

# require 'bubble_ruby/single_association_populator'

# module BubbleRuby
#   RSpec.describe SingleAssociationPopulator do
#     describe '#call' do
#       let(:single_association_populator) { described_class.new }
#       describe '#build_constraint_query' do
#         it "returns an SQL query to check if there's foreign_key constraint" do
#           expected_query = <<-SQL
#           SELECT TABLE_NAME, CONSTRAINT_TYPE, CONSTRAINT_NAME
#           FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
#           WHERE TABLE_NAME = 'Nurse';
#           SQL
#           query = single_association_populator.send(:build_constraint_query, 'Nurse').split

#           expect(query).to eq(expected_query.split)
#         end
#       end

#       describe '#build_populator_query' do
#         it 'returns an SQL query to make the association between the tables' do
#           expected_query = <<-SQL
#             UPDATE "ratings"
#             SET "shift_id" = "shift".id
#             FROM "shift"
#             WHERE "shift".bubble_id = "ratings"."Shift";
#           SQL

#           query = single_association_populator.send(:build_populator_query, 'ratings', 'shift_id').split

#           expect(query).to eq(expected_query.split)
#         end
#       end

#       describe '#execute_query' do
#         it 'executes the query passed as argument' do
#           allow(single_association_populator).to receive(:execute_query).and_return('query executed')

#           result = single_association_populator.send(:execute_query, 'bla')

#           expect(result).to eq('query executed')
#         end
#       end
#     end
#   end
# end
