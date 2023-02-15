# frozen_string_literal: true

module Query
  module Create
    module Column
      def self.call(table_name, name, type)
        <<-SQL
        ALTER TABLE \"#{table_name}\"
        ADD COLUMN \"#{name}\" #{type};
        SQL
      end
    end
  end
end
