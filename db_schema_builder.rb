# frozen_string_literal: true

require 'json'
require './tables_name_source'
require './bubble_table_fetcher'

# class DbSchemaBuilder
class DbSchemaBuilder
  attr_reader :table_names, :schema

  def initialize
    @table_names = TABLE_NAMES
    @schema = []
    @fetcher = BubbleTableFetcher.new
  end

  def call
    @table_names.each { |name| build_schema(name) }
    export_schema
    self
  end

  private

  def build_schema(name)
    table = {}
    table[:name] = name
    table[:body] = @fetcher.call(name.downcase.gsub(' ', ''))
    @schema << table
  end

  def export_schema
    File.write('schema.rb', @schema)
    File.write('schema.json', @schema.to_json)
  end
end

DbSchemaBuilder.new.enviroment
