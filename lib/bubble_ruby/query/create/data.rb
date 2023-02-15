# frozen_string_literal: true

module Query
  module Create
    module Data
      def self.call(table_name, record)
        <<-SQL
        INSERT INTO \"#{table_name}\" (#{rename_id_to_bubble_id(record.keys).join(', ')})
        VALUES (#{convert_data(record.values).join(', ')})
        SQL
      end
    end
  end
end
