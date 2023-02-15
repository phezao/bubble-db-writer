# frozen_string_literal: true

module Query
  module Update
    module ColumnType
      def self.call(table_name, column_name, column_type)
        <<-SQL
          ALTER TABLE \"#{table_name}\"
          ALTER COLUMN \"#{column_name}\" TYPE #{column_type};
        SQL
      end
    end
  end
end
