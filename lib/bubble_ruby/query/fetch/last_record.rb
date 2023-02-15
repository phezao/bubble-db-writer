# frozen_string_literal: true

module Query
  module Fetch
    module LastRecord
      def self.call(table_name)
        <<-SQL
          SELECT * FROM \"#{table_name}\"
          WHERE "Created Date" IS NOT NULL
          ORDER BY "Created Date" DESC LIMIT 1;
        SQL
      end
    end
  end
end
