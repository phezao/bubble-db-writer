# frozen_string_literal: true

module BubbleRuby
  class DB::Schema::Table::Column
    require_relative 'column/create'
    require_relative 'column/check'

    Type = lambda do |value|
      return 'JSON'        if value.keys.include?('$ref')
      return 'TIMESTAMPTZ' if value.keys.include?('format') && value['format'] == 'date-time'
      return 'TEXT'        if value['type'] == 'string' || value['type'] == 'option set'
      return 'FLOAT8'      if value['type'] == 'number'
      return 'BOOLEAN'     if value['type'] == 'boolean'
      return 'TEXT ARRAY'  if value['type'] == 'array'
    end

    attr_reader :name, :type, :table_name

    def initialize(table_name:, name:, type:)
      self.table_name = table_name
      self.name       = name
      self.type       = Type[type]
    end

    def create
      Create.call(self)
    end

    private

    attr_writer :name, :type, :table_name
  end
end
