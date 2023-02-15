# frozen_string_literal: true

module Query
  module Create
    module Table
      def self.call(table)
        query = ['id uuid DEFAULT gen_random_uuid () PRIMARY KEY']
        table[:body].each { |key, value| query << "\"#{key}\" #{value}" }
        "
          CREATE TABLE \"#{table[:name]}\" (
            #{query.join(', ')}
          );
        "
      end
    end
  end
end
