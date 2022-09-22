# frozen_string_literal: true

require_relative './pg_service'

# class DbTableWriter
class DbTableWriter
  attr_reader :schema

  def initialize(schema, pg_service)
    @schema = schema
    @pg_service = pg_service
  end

  def call
    @schema.map do |table|
      sql_query = build_sql_query(table)
      @pg_service.exec(sql_query)
      sql_query
    end
  end

  private

  def build_sql_query(table)
    query = ['id uuid DEFAULT gen_random_uuid () PRIMARY KEY']
    table[:body].each { |key, value| query << "\"#{key}\" #{value}" }
    "
      CREATE TABLE \"#{table[:name]}\" (
        #{query.join(', ')}
      );
    "
  end
end

# pg_service = PgService.new

# DbTableWriter.new(SCHEMA, pg_service).call
