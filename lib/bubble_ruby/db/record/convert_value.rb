# frozen_string_literal: true

module BubbleRuby
  module DB::Record
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
  end
end
