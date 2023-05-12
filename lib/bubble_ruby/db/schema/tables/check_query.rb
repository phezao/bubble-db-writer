# frozen_string_literal: true

module BubbleRuby
  class DB::Schema::Tables
    module CheckQuery
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
