# frozen_string_literal: true

require 'pg'
require 'dotenv'
require './schema'

Dotenv.load

# class DbTableWriter
class DbTableWriter
  attr_reader :schema

  def initialize
    @schema = SCHEMA
    @pg = PG.connect(
      host: ENV['DB_HOST'],
      dbname: ENV['DB_NAME'],
      port: ENV['DB_PORT'],
      user: ENV['DB_USER'],
      password: ENV['DB_PASSWORD']
    )
  end

  def call
    @schema.each do |table|
      sql_query = build_sql_query(table)
      @pg.exec(sql_query)
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

DbTableWriter.new.call
