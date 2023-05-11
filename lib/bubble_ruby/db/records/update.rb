# frozen_string_literal: true

require_relative 'query_builder'
require_relative 'data_type_checker'
require 'byebug'

module BubbleRuby
  module DB::Records::Update
    def self.call(bubble_api_service:, middleware:, table_name:, limit: nil)
      @bubble_api_service = bubble_api_service
      query = BubbleRuby::DB::Records::FetchQuery.call(table_name: table_name, limit: limit)
      response = middleware.execute(query)

      response.each do |data|
        data_mapped = DB::Record::Mapping.new(table_name: table_name, data: data)
        data_mapped.analyze
      end
    end
  end
end
