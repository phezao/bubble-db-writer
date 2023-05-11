# frozen_string_literal: true

module BubbleRuby
  module DB::Schema::Table::Column
    module CreateQuery
      def self.call(table_column)
        table_column.is_a?(Table::Column) or raise TypeError

        <<-SQL
          ALTER TABLE \"#{table_column.table_name}\"
          ADD COLUMN \"#{table_column.name}\" #{table_column.type};
        SQL
      end
    end
  end
end
