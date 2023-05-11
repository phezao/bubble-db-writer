# frozen_string_literal: true

module BubbleRuby
  class DB::Record
    attr_accessor :data

    def initialize(data)
      self.data = data
    end
  end
end
