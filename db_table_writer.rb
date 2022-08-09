# frozen_string_literal: true

require './schema'

# class DbTableWriter
class DbTableWriter
  attr_reader :schema

  def initialize(schema, pg_service)
    @schema = schema
    @pg = pg_service
  end

  def call
    @schema.map do |table|
      sql_query = build_sql_query(table)
      @pg.exec(sql_query)
      sql_query
    end
  end

  private

  def build_sql_query(table)
    query = ['id SERIAL PRIMARY KEY']
    table[:body].each { |key, value| query << "\"#{key}\" #{value}" }
    <<-SQL
        CREATE TABLE \"#{table[:name]}\" (
          #{query.join(', ')}
        );
    SQL
  end
end

# pg_service = PgService.new

# DbTableWriter.new(SCHEMA, pg_service).call
