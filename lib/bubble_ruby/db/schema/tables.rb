# frozen_string_literal: true

module BubbleRuby
  class DB::Schema::Tables
    require_relative 'tables/factory'
    require_relative 'tables/check_query'
    require_relative 'tables/fetch'
    require_relative 'tables/response'

    attr_reader :collection

    def initialize(endpoint:)
      self.collection = build_tables(endpoint)
    end

    def find_table(name:)
      collection.find { |table| table.name == name }
    end

    private

    attr_writer :collection

    def build_tables(endpoint)
      json = Fetch.call(endpoint: endpoint)
      response = Response.new(json)
      Factory.new(response).call
    end
  end
end
