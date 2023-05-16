
module BubbleRuby::Query::Create
  module
end

    def build_insert_data_query(table_name, record)
      <<-SQL
      INSERT INTO \"#{table_name}\" (#{rename_id_to_bubble_id(record.keys).join(', ')})
      VALUES (#{convert_data(record.values).join(', ')})
      SQL
    end
