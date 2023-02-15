# frozen_string_literal: true

module Query
  module Fetch
    module Record
      def self.call(table_name, column_name)
        <<-SQL
          SELECT * FROM \"#{table_name}\"
          WHERE \"#{column_name}\" IS NOT NULL
          LIMIT 1;
        SQL
      end
    end
  end
end
