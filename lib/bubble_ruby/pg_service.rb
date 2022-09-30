# frozen_string_literal: true

require 'pg'
require 'dotenv'

Dotenv.load

module BubbleRuby
  # class PgService is a PG instance to execute PostgreSQL queries
  class PgService
    def initialize
      @pg = PG.connect(
        host: ENV['DB_HOST'],
        dbname: ENV['DB_NAME'],
        port: ENV['DB_PORT'],
        user: ENV['DB_USER'],
        password: ENV['DB_PASSWORD']
      )
    end

    def exec(query)
      @pg.exec(query)
    end
  end
end
