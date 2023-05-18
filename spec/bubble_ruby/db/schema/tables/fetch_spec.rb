# frozen_string_literal: true

require 'spec_helper'
require 'json'
require_relative '../../../../../lib/bubble_ruby'

RSpec.describe BubbleRuby::DB::Schema::Tables::Fetch do
  describe '.call' do
    xit 'returns json' do
      request = BubbleRuby::DB::Schema::Tables::Fetch.call(endpoint: 'https://official-joke-api.appspot.com/random_joke')

      response = JSON.parse(request)

      expect(response).to be_a(Hash)
    end
  end
end
