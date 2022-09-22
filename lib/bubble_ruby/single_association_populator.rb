# frozen_string_literal: true

require_relative 'query_builder'
require 'byebug'

module BubbleRuby
  # class SingleAssociationPopulator
  class SingleAssociationPopulator
    include BubbleRuby::QueryBuilder

    def call(table_name)
      res = execute_query(build_constraint_query(table_name))

      return unless res.field_values('constraint_type').include?('FOREIGN KEY')

      res.column_values(2).each do |value|
        next unless value.match?(/fkey/)

        other_table_name_id = value.match(/_(.*_id)_fkey/).captures.first
        execute_query(build_populator_query(table_name, other_table_name_id))
      end
    end

    private

    def build_populator_query(table_name, other_table_name_id)
      columns_query = build_check_column_names_query(table_name)
      pg_columns = execute_query(columns_query).column_values(3)
      other_table_name = other_table_name_id.match(/(.*)_id/).captures.first
      table_column_name = pg_columns.select { |name| name.gsub(' ', '').downcase == other_table_name }.first
      build_update_associations_query(table_name, other_table_name_id, other_table_name, table_column_name)
    end
  end
end
