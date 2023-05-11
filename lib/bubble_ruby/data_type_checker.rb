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

    def check_data_type_and_return_converted_value(original_value, value_to_convert)
      return value_to_convert.to_i if original_value.instance_of?(Integer)
      return true if original_value.is_a?(TrueClass)
      return false if original_value.is_a?(FalseClass)
      return value_to_convert.to_f if original_value.is_a?(Float)

      if original_value.is_a?(Array) && !value_to_convert.nil?
        return value_to_convert.gsub('{', '').gsub('}',
                                                   '').split(',')
      end
      return JSON.parse(value_to_convert.gsub(/\*/, '"')) if original_value.is_a?(Hash) && !value_to_convert.nil?
      return value_to_convert if original_value.nil? || value_to_convert.nil?
      if original_value.is_a?(String) && original_value.match?(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}.\d{3}Z/)
        return DateTime.parse(value_to_convert)
      end

      value_to_convert
    end
  end
end
