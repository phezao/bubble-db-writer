# frozen_string_literal: true

module BubbleRuby
  module DB::Schema::Tables
    require_relative 'tables/build'
    require_relative 'tables/check'
    require_relative 'tables/fetch'

    def self.new(endpoint:)
      Build.call(endpoint: endpoint)
    end
  end
end
