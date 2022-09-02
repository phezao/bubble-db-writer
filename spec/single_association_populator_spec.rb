# frozen_string_literal: true

require 'spec_helper'
require_relative './../single_association_populator'

RSpec.describe SingleAssociationPopulator do
  describe '#call' do
    let(:pg_service) { double }
    let(:table_names) { ['Nurse'] }
    let(:single_association_populator) { described_class.new(pg_service, table_names) }
    describe '#build_constraint_query' do
      it "returns an SQL query to check if there's foreign_key constraint" do
        expected_query = <<-SQL
          SELECT TABLE_NAME, CONSTRAINT_TYPE, CONSTRAINT_NAME
          FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
          WHERE TABLE_NAME = 'Nurse'
        SQL
        query = single_association_populator.send(:build_constraint_query, 'Nurse').split

        expect(query).to eq(expected_query.split)
      end
    end

    describe '#build_populate_query' do
      it 'returns an SQL query to make the association between the tables' do
        expected_query = <<-SQL
        UPDATE "Ratings"
        SET shift_id = "Shift".id
        FROM "Shift"
        WHERE "Shift".bubble_id = "Ratings"."Shift"
        SQL

        query = single_association_populator.send(:build_populate_query, 'Ratings', 'shift_id').split

        expect(query).to eq(expected_query.split)
      end
    end

    describe '#execute_query' do
      it 'executes the query passed as argument' do
        allow(pg_service).to receive(:exec).and_return('query executed')

        result = single_association_populator.send(:execute_query, 'bla')

        expect(result).to eq('query executed')
      end
    end
  end
  # connect to pg_service
  # send query to check if there's foreign_key constraint
  # SELECT TABLE_NAME, CONSTRAINT_TYPE, CONSTRAINT_NAME
  # FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
  # WHERE TABLE_NAME = \'#{table_name}\'
  # if the constraint exists, then execute the query to make association
  # UPDATE #{table_name}
  # SET other_table_name_id = "Other Table".id
  # FROM "Other Table"
  # WHERE "Other Table".bubble_id = #{table_name}."Other Table"
  # if doesn't exist go to the next table
end
