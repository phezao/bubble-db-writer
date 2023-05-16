# frozen_string_literal: true

require 'json'
# require 'httparty'

module BubbleRuby
  class DB::Schema::Tables
    module Fetch
      def self.call(endpoint:)
        response = HTTParty.get(endpoint)
        JSON.parse(response)
      end
    end
  end
end
