# frozen_string_literal: true

module BubbleRuby
  module DB::Record::UpdateQuery
    def self.call(record)
      record.is_a?(DB::Record) or raise TypeError

      value = record.bubble_data_type.is_a?(Hash) ? record.column_value : "\'#{record.column_value}\""

      <<-SQL
        UPDATE \"#{record.table_name}\"
        SET \"#{record.column_name}\" = #{value}
        WHERE bubble_id = \'#{record.bubble_id}\'
      SQL
    end
  end
end
