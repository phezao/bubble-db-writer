# frozen_string_literal: true

module Query
  module Fetch
    module TablesName
      def self.call
        <<-SQL
          SELECT table_name FROM information_schema.tables
          WHERE table_schema = 'public'
          ORDER BY table_name;
        SQL
      end
    end
  end
end
