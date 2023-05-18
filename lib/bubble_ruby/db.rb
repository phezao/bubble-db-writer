# frozen_string_literal: true

module BubbleRuby
  class DB
    require_relative 'db/schema'
    require_relative 'db/middleware'

    attr_reader :endpoint, :schema

    def initialize
      self.endpoint = ENV['BUBBLE_SWAGGER_DOC_ENDPOINT']
      self.schema   = nil
    end

    def create
      self.schema = DB::Schema.new(endpoint: endpoint)
    end

    alias update create

    def migrate
      !schema.nil? or raise StandardError, 'Schema not yet created or imported, run #create'

      schema.migrate
    end

    private

    attr_writer :endpoint, :schema
  end
end
