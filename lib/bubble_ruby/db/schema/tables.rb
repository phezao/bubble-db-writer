# frozen_string_literal: true

module BubbleRuby
  class DB::Schema::Tables
    require_relative 'tables/build'
    require_relative 'tables/check_query'
    require_relative 'tables/fetch'
    require_relative 'tables/response'

    attr_accessor :collection

    def initialize(endpoint:)
      self.collection = Build.call(endpoint: endpoint)
    end

    def find_table(name:)
      collection.find { |table| table.name == name }
    end
  end
end
