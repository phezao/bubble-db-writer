# frozen_string_literal: true

require 'byebug'

# class TableSingleAssociator is responsible to create associations 1-to-1 and 1-to-many checking for fields that have a bubble_id
class TableSingleAssociator
  attr_reader :queries

  def initialize(bubble_api_service, pg_service)
    @bubble_api = bubble_api_service
    @pg = pg_service
    @queries = []
  end

  def call(name)
    string_table_columns = get_string_columns(name)
    return unless string_table_columns

    bubble_id_matcher(name, string_table_columns)
    @queries
  end

  private

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
