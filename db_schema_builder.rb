# frozen_string_literal: true

require 'json'
require './tables_name_source'
require './bubble_table_fetcher'
require './bubble_api_service'

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
    if Dir.children('./').include?('schema.rb')
      export_sequence_schema
    else
      export_first_schema
    end
  end

  def export_sequence_schema
    last_schema = Dir.children('./').select { |name| name.match?(/schema\d*.rb/) }.last
    new_export_index = last_schema[/schema(.*?).rb/].to_i + 1
    File.write("schema#{new_export_index}.rb", @schema)
    File.write("schema#{new_export_index}.json", @schema.to_json)
  end

  def export_first_schema
    File.write('schema.json', @schema.to_json)
    File.write('schema.rb', @schema)
  end
end

bubble_api_service = BubbleApiService.new
bubble_table_fetcher = BubbleTableFetcher.new(bubble_api_service)

DbSchemaBuilder.new(bubble_table_fetcher, TABLE_NAMES).call
