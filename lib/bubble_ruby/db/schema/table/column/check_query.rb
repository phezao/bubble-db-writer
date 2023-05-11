# frozen_string_literal: true

module BubbleRuby
  module DB::Schema::Table::Column
    module CheckQuery
      def self.call(table)
        table.is_a?(Table) or raise TypeError

        <<-SQL
          SELECT * FROM information_schema.columns
          WHERE table_schema = 'public'
          AND table_name = \'#{table.name}\'
        SQL
      end
    end
  end
end
