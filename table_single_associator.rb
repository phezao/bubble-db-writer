# frozen_string_literal: true

require './bubble_api_service'
require './pg_service'
require './tables_name_source'
require 'byebug'

# class TableSingleAssociator
class TableSingleAssociator
  attr_reader :queries

  def initialize(bubble_api_service, table_names, pg_service)
    @bubble_api = bubble_api_service
    @table_names = table_names
    @pg = pg_service
    @queries = []
  end

  def call
    @table_names.each do |name|
      string_table_columns = get_string_columns(name)
      next unless string_table_columns

      bubble_id_matcher(name, string_table_columns)
    end
    @queries
  end

  def get_string_columns(name)
    response = @bubble_api.call(name.downcase.gsub(' ', ''))['results'].first.select do |_k, v|
      v.is_a? String
    end

    return nil if response.keys.include?(:"error: table is empty")

    response
  end

  def bubble_id_matcher(table, record)
    record.map do |key, value|
      if value.match?(/\A\d{13}x\d{18}\z/) && key != '_id' && key != 'Created By'
        insert_foreign_key(table,
                           key)
      end
    end
  end

  def insert_foreign_key(table, column)
    query = build_query(table, column)
    @queries << query
    @pg.exec(query)
  end

  def build_query(table, column)
    <<-SQL
      ALTER TABLE \"#{table}\" ADD COLUMN \"#{column.downcase}_id\" uuid
      REFERENCES \"#{column}\";
    SQL
  end
end

# bubble_api_service = BubbleApiService.new
# pg_service = PgService.new

# TableSingleAssociator.new(bubble_api_service, TABLE_NAMES, pg_service).call
