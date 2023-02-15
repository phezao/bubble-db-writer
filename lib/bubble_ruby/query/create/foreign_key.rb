# frozen_string_literal: true

module Query
  module Create
    module ForeignKey
      def self.call(table, column)
        <<-SQL
          ALTER TABLE \"#{table}\" ADD COLUMN \"#{column.gsub(' ', '').downcase}_id\" uuid
          REFERENCES \"#{column}\";
        SQL
      end
    end
  end
end
