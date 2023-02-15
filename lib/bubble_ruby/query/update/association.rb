# frozen_string_literal: true

module Query
  module Update
    module Association
      def self.call(table_name, other_table_name_id, other_table_name, table_column_name)
        <<-SQL
            UPDATE \"#{table_name}\"
            SET \"#{other_table_name_id}\" = \"#{other_table_name}\".id
            FROM \"#{other_table_name}\"
            WHERE \"#{other_table_name}\".bubble_id = \"#{table_name}\".\"#{table_column_name}\";
        SQL
      end
    end
  end
end
