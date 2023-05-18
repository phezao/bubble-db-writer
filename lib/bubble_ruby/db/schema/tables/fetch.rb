# frozen_string_literal: true

# require 'httparty'

module BubbleRuby
  class DB::Schema::Tables
    module Fetch
      def self.call(endpoint:)
        ::HTTParty.get(endpoint)
      end
    end
  end
end
