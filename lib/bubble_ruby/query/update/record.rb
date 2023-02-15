# frozen_string_literal: true

module Query
  module Update
    module Record
      def self.call(table_name, column_name, column_value, bubble_id, bubble_data_type)
        if bubble_data_type.is_a?(Hash)
          <<-SQL
            UPDATE \"#{table_name}\"
            SET \"#{column_name}\" = #{column_value}
            WHERE bubble_id = \'#{bubble_id}\'
          SQL
        else
          <<-SQL
            UPDATE \"#{table_name}\"
            SET \"#{column_name}\" = \'#{column_value}\'
            WHERE bubble_id = \'#{bubble_id}\'
          SQL
        end
      end
    end
  end
end
