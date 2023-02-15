# frozen_string_literal: true

module Query
  module Fetch
    module ColumnsName
      def self.call(table_name)
        <<-SQL
        SELECT * FROM information_schema.columns
        WHERE table_schema = 'public'
        AND table_name = \'#{table_name}\'
        SQL
      end
    end
  end
end
