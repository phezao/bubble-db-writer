# frozen_string_literal: true

module BubbleRuby
  module DB::Records::FetchQuery
    def self.call(table_name:, limit: nil)
      filter = limit.nil? ? '' : "LIMIT #{limit}"

      <<-SQL
        SELECT * FROM \"#{table_name}\"
        WHERE "Created Date" IS NOT NULL
        ORDER BY "Created Date" DESC #{filter};
      SQL
    end
  end
end
