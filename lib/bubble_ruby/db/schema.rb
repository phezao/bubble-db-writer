# frozen_string_literal: true

module BubbleRuby
  class DB::Schema
    require_relative 'schema/tables'
    require_relative 'schema/migrate'

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

    private

    attr_accessor :tables
  end
end
