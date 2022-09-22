# frozen_string_literal: true

require './tables_name_source'
require './bubble_table_fetcher'
require './bubble_api_service'
require './exporter_service'

# class DbSchemaBuilder
class DbSchemaBuilder
  attr_reader :table_names, :schema

  def initialize(bubble_table_fetcher, table_names)
    @table_names = table_names
    @schema = []
    @fetcher = bubble_table_fetcher
  end

  def call
    @table_names.each { |name| build_schema(name) }
    @schema
  end

  private

  def build_schema(name)
    table = {}
    table[:name] = name
    table[:body] = @fetcher.call(name)
    @schema << table
  end
end

# bubble_api_service = BubbleApiService.new
# bubble_table_fetcher = BubbleTableFetcher.new(bubble_api_service)

# schema_builder = DbSchemaBuilder.new(bubble_table_fetcher, TABLE_NAMES)
# schema = schema_builder.call

# ExporterService.write('schema', schema)
