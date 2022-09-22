require_relative 'pg_service'

module BubbleRuby
  module QueryBuilder
    PG = PgService.new

    def execute_query(query)
      query_to_exec = query
      puts query

      PG.exec(query_to_exec)
    end

    # Queries for SchemaRefiner
    def build_add_table_query(table)
      query = ['id uuid DEFAULT gen_random_uuid () PRIMARY KEY']
      table[:body].each { |key, value| query << "\"#{key}\" #{value}" }
      "
        CREATE TABLE \"#{table[:name]}\" (
          #{query.join(', ')}
        );
      "
    end

    def build_add_column_query(table_name, name, type)
      <<-SQL
      ALTER TABLE \"#{table_name}\"
      ADD COLUMN \"#{name}\" #{type};
      SQL
    end

    def build_check_table_names_query
      <<-SQL
      SELECT table_name FROM information_schema.tables
      WHERE table_schema = 'public'
      ORDER BY table_name;
      SQL
    end

    def build_check_column_names_query(table_name)
      <<-SQL
      SELECT * FROM information_schema.columns
      WHERE table_schema = 'public'
      AND table_name = \'#{table_name}\'
      SQL
    end

    # Queries for PostgrePopulator
    def build_fetch_last_record_from_db_query(table_name)
      <<-SQL
        SELECT * FROM \"#{table_name}\"
        WHERE "Created Date" IS NOT NULL
        ORDER BY "Created Date" DESC LIMIT 1;
      SQL
    end

    def build_insert_data_query(table_name, record)
      <<-SQL
      INSERT INTO \"#{table_name}\" (#{rename_id_to_bubble_id(record.keys).join(', ')})
      VALUES (#{convert_data(record.values).join(', ')})
      SQL
    end

    # Queries for SingleAssociationPopulator
    def build_constraint_query(table_name)
      <<-SQL
          SELECT TABLE_NAME, CONSTRAINT_TYPE, CONSTRAINT_NAME
          FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
          WHERE TABLE_NAME = \'#{table_name}\';
      SQL
    end

    def build_update_associations_query(table_name, other_table_name_id, other_table_name, table_column_name)
      <<-SQL
          UPDATE \"#{table_name}\"
          SET \"#{other_table_name_id}\" = \"#{other_table_name}\".id
          FROM \"#{other_table_name}\"
          WHERE \"#{other_table_name}\".bubble_id = \"#{table_name}\".\"#{table_column_name}\";
      SQL
    end

    # Queries for TableSingleAssociator
    def build_check_record_query(table_name, column_name)
      <<-SQL
        SELECT * FROM \"#{table_name}\"
        WHERE \"#{column_name}\" IS NOT NULL
        LIMIT 1;
      SQL
    end

    def build_create_foreign_key_query(table, column)
      <<-SQL
        ALTER TABLE \"#{table}\" ADD COLUMN \"#{column.gsub(' ', '').downcase}_id\" uuid
        REFERENCES \"#{column}\";
      SQL
    end
  end
end
