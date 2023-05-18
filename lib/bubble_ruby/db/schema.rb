# frozen_string_literal: true

module BubbleRuby
  class DB::Schema
    require_relative 'schema/tables'
    require_relative 'schema/table'
    require_relative 'schema/migrate'

    attr_accessor :tables, :middleware

    def initialize(endpoint:)
      self.tables     = Tables.new(endpoint: endpoint)
      self.middleware = DB::Middleware.new
    end

    def table_names
      tables.map(&:name)
    end

    def length
      tables.length
    end

    def migrate
      Migrate.call(self, middleware)
    end
  end
end
