# frozen_string_literal: true

module BubbleRuby
  # BubbleRuby::DataTypeChecker is a module to check the data type and return a response
  module DataTypeChecker
    def check_data_type_and_return_formatted_value(value)
      if value.instance_of?(Integer) || value.is_a?(TrueClass) || value.is_a?(FalseClass) || value.is_a?(Float)
        return value
      end
      return "\'{#{value.join(', ')}}\'" if value.is_a?(Array)
      return "\'#{value.to_json.gsub(/'/, ' ')}\'" if value.is_a?(Hash) || value.nil?
      return "\'#{value}\'" if value.match?(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}.\d{3}Z/)
      return "\'#{value.gsub(/'/, ' ').gsub(/"/, '%')}\'" if value.match?(/\d{13}x\d{18}/) || value.instance_of?(String)
    end

    def check_data_type_and_return_postgre_type(value)
      return 'JSON' if value.keys.include?('$ref')
      return 'TIMESTAMPTZ' if value.keys.include?('format') && value['format'] == 'date-time'
      return 'TEXT' if value['type'] == 'string' || value['type'] == 'option set'
      return 'FLOAT8' if value['type'] == 'number'
      return 'BOOLEAN' if value['type'] == 'boolean'
      return 'TEXT ARRAY' if value['type'] == 'array'
    end
  end
end
