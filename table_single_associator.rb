# frozen_string_literal: true

require './bubble_api_service'
require './tables_name_source'
require 'byebug'

# class TableSingleAssociator
class TableSingleAssociator
  def initialize(bubble_api_service, table_names, pg_service)
    @bubble_api = bubble_api_service
    @table_names = table_names
    @pg = pg_service
    @queries = []
  end

  def call
    @table_names.each do |name|
      string_table_columns = @bubble_api.call(name.downcase.gsub(' ', '')).first.select { |_k, v| v.is_a? String }
      bubble_id_matcher(name, string_table_columns)
    end
    @queries
  end

  private

  def bubble_id_matcher(table, record)
    record.each do |key, value|
      insert_foreign_key(table, key) if value.match?(/\d{13}x\d{18}/) && key != '_id' && key != 'Created By'
    end
  end

  def insert_foreign_key(table, column)
    query = build_query(table, column)
    @queries << query
    @pg.exec(query)
  end

  def build_query(table, column)
    <<-SQL
      ALTER TABLE \"#{table}\" ADD COLUMN #{column.downcase}_id INT
      REFERENCES \"#{column}\";
    SQL
  end
end

# bubble_api_service = BubbleApiService.new
# pg_service = PgService.new

# TableSingleAssociator.new(bubble_api_service, TABLE_NAMES, pg_service).call
