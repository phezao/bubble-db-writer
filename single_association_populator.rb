# frozen_string_literal: true

require 'byebug'
require './pg_service'
require './tables_name_source'

# class SingleAssociationPopulator
class SingleAssociationPopulator
  def initialize(pg_service, table_names)
    @table_names = table_names
    @pg_service = pg_service
  end

  def call
    @table_names.each do |table_name|
      res = execute_query(build_constraint_query(table_name))

      next unless res.field_values('constraint_type').include?('FOREIGN KEY')

      res.column_values(2).each do |value|
        next unless value.match?(/fkey/)

        other_table_name_id = value.match(/_(.*_id)_fkey/).captures.first
        execute_query(build_populator_query(table_name, other_table_name_id))
      end
    end
  end

  private

  def build_constraint_query(table_name)
    <<-SQL
        SELECT TABLE_NAME, CONSTRAINT_TYPE, CONSTRAINT_NAME
        FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
        WHERE TABLE_NAME = \'#{table_name}\'
    SQL
  end

  def build_populate_query(table_name, other_table_name_id)
    other_table_name = other_table_name_id.match(/(.*)_id/).captures.first.capitalize
    <<-SQL
        UPDATE \"#{table_name}\"
        SET #{other_table_name_id} = \"#{other_table_name}\".id
        FROM \"#{other_table_name}\"
        WHERE \"#{other_table_name}\".bubble_id = \"#{table_name}\".\"#{other_table_name}\"
    SQL
  end

  def execute_query(query)
    query_to_exec = query

    @pg_service.exec(query_to_exec)
  end
end

pg_service = PgService.new

populator = SingleAssociationPopulator.new(pg_service, TABLE_NAMES)

populator.call
