# frozen_string_literal: true

module Query
  module Fetch
    module LimitedRecordsDesc
      def self.call(table_name, limit)
        <<-SQL
          SELECT * FROM \"#{table_name}\"
          WHERE "Created Date" IS NOT NULL
          ORDER BY "Created Date" DESC LIMIT #{limit};
        SQL
      end
    end
  end
end
