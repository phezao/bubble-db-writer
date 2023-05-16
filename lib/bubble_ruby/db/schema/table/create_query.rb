# frozen_string_literal: true

module BubbleRuby
  class DB::Schema::Table
    module CreateQuery
      def self.call(table)
        table.is_a?(DB::Schema::Table) or raise TypeError

        query = ['id uuid DEFAULT gen_random_uuid () PRIMARY KEY']
        table.body.each { |table_column| query << "\"#{table_column.name}\" #{table_column.type}" }
        "
          CREATE TABLE \"#{table.name}\" (
            #{query.join(', ')}
          );
        "
      end
    end
  end
end
