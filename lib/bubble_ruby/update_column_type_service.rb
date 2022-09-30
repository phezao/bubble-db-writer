# frozen_string_literal: true

require_relative 'query_builder'
require 'byebug'

module BubbleRuby
  # class UpdateColumnTypeService is responsible to update the column_type from integer to float8 as bubble doesn't use integers, only floats
  class UpdateColumnTypeService
    include QueryBuilder

    def call(table_name)
      query = build_check_column_names_query(table_name)
      res = execute_query(query)

      res.each do |column|
        if column['data_type'] == 'integer'
          execute_query(build_update_column_type(table_name, column['column_name'],
                                                 'FLOAT8'))
        end
      end
    end
  end
end
