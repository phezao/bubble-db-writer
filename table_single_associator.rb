# frozen_string_literal: true

require 'pg'
require './bubble_api_service'
require './tables_name_source'

# class TableSingleAssociator
class TableSingleAssociator
  def initialize
    @bubble_api = BubbleApiService.new
    @table_names = TABLE_NAMES
    @pg = PG.connect(
      host: ENV['DB_HOST'],
      dbname: ENV['DB_NAME'],
      port: ENV['DB_PORT'],
      user: ENV['DB_USER'],
      password: ENV['DB_PASSWORD']
    )
  end

  def call
    @table_names.each do |name|
      bubble_id_matcher(name, @bubble_api.call(name.downcase.gsub(' ', '')).first.select { |_k, v| v.is_a? String })
    end
  end

  def bubble_id_matcher(table, record)
    record.each do |key, value|
      insert_foreign_key(table, key) if value.match?(/\d{13}x\d{18}/) && key != '_id' && key != 'Created By'
    end
  end

  def insert_foreign_key(table, column)
    puts <<-SQL
      ALTER TABLE #{table} ADD COLUMN #{column.downcase}_id INT
      REFERENCES #{column};
    SQL
  end
end

TableSingleAssociator.new.call
