# frozen_string_literal: true

module BubbleRuby
  class DB::Record::Column
    attr_accessor :bubble_data, :table_name, :column_name, :column_value

    def initialize(bubble_data:, table_name:, column_name:)
      self.bubble_data = bubble_data
      self.table_name = table_name
      self.column_name = column_name
      self.column_value = nil
    end

    def column_value
      self.column_value = if bubble_data.nil?
                            check_column_type_and_return_null_type(column_name, table_name)
                          else
                            Format.call(bubble_data)
                          end

      unless column_value.instance_of?(Integer) || column_value.is_a?(TrueClass) || column_value.is_a?(FalseClass) || column_value.is_a?(Float) || bubble_data[table_name].is_a?(Hash)
        self.column_value = column_value.gsub('"', '').gsub("'", '')
      end
    end

    private

    def check_column_type_and_return_null_type(column_name, table_name)
      query = build_check_column_names_query(table_name)
      res = execute_query(query)

      type = res.find { |column| column['column_name'] == column_name }
      return 0 if type['data_type'] == 'double precision'

      'null'
    end
  end
end
