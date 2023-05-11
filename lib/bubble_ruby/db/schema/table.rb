# frozen_string_literal: true

module BubbleRuby
  class DB::Schema::Table
    require_relative 'table/column'
    require_relative 'table/create'

    attr_accessor :name, :body

    def initialize(name:, body: [])
      self.name = name
      self.body = body
    end

    def create_query
      CreateQuery.call(self)
    end
  end
end
