# frozen_string_literal: true

module BubbleRuby
  module DB::Record
    class Mapping
      module ConvertValue
        IsArray = ->(original, convert) { original.is_a?(Array) && !convert.nil? }
        IsHash = ->(original, convert) { original.is_a?(Hash) && !convert.nil? }
        IsDate = lambda { |original|
          original.is_a?(String) && original.match?(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}.\d{3}Z/)
        }
        ConvertToArray = ->(value) { value.gsub('{', '').gsub('}', '').split(',') }
        ConvertToHash = ->(value) { JSON.parse(value.gsub(/\*/, '"')) }

        def self.call(original_value, value_to_convert)
          return value_to_convert.to_i              if original_value.is_a?(Integer)
          return true                               if original_value.is_a?(TrueClass)
          return false                              if original_value.is_a?(FalseClass)
          return value_to_convert.to_f              if original_value.is_a?(Float)
          return ConvertToArray[value_to_convert]   if IsArray[original_value, value_to_convert]
          return ConvertToHash[value_to_convert]    if IsHash[original_value, value_to_convert]
          return value_to_convert                   if original_value.nil? || value_to_convert.nil?
          return DateTime.parse(value_to_convert)   if IsDate[original_value, value_to_convert]

          value_to_convert
        end
      end

      attr_accessor :data, :table_name, :bubble_record

      def initialize(table_name:, data:)
        self.table_name = table_name
        self.data = data
        self.bubble_record = Bubble.new(table_name: table_name, bubble_id: data['bubble_id'])
      end

      def analyze
        return unless bubble_record.data

        data.each do |key, value|
          next if key.match?(/id/)

          converted_value = ConvertValue.call(bubble_record.data[key], value)
          next if converted_value.is_a?(DateTime) && (DateTime.parse(bubble_record.data[key]) == converted_value)
          next if bubble_record.data[key] == converted_value

          column_value = format_column_value(bubble_record.data[key], table_name, key)
          unless column_value.instance_of?(Integer) || column_value.is_a?(TrueClass) || column_value.is_a?(FalseClass) || column_value.is_a?(Float) || bubble_record.data[key].is_a?(Hash)
            column_value = column_value.gsub('"', '').gsub("'", '')
          end

          execute_query(build_update_record_query(table_name, key, column_value,
                                                  bubble_id, bubble_record.data[key]))
        end
      end

      def format_column_value(bubble_data, table_name, column_name)
        if bubble_data.nil?
          check_column_type_and_return_null_type(column_name, table_name)
        else
          Format.call(bubble_data)
        end
      end

      def check_column_type_and_return_null_type(column_name, table_name)
        query = build_check_column_names_query(table_name)
        res = execute_query(query)

        type = res.select { |column| column['column_name'] == column_name }.first
        return 0 if type['data_type'] == 'double precision'

        'null'
      end
    end
  end
end
