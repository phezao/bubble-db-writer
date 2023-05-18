# frozen_string_literal: true

module BubbleRuby
  module DB::Record
    class Bubble::DataPoint
      def initialize(column_name:, column_value:)
        self.column_name = column_name
        self.column_value = column_value
      end

      def matches(pg_value)
        converted_value = DB::Record::ConvertValue.call(bubble_data[pg_column_name], pg_value)

        if converted_value.is_a?(DateTime) && (DateTime.parse(bubble_data[pg_column_name]) == converted_value)
          return false
        end
        return false if bubble_data[pg_column_name] == converted_value

        true
      end
    end
  end
end
