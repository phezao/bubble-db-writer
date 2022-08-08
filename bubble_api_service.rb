# frozen_string_literal: true

require 'httparty'
require 'dotenv'

Dotenv.load

# class BubbleApiService
class BubbleApiService
  def initialize
    @bubble_endpoint = ENV['API_ENDPOINT']
  end

  def call(name, limit = 1)
    extract_api_response(make_api_call(name, limit))
  end

  private

  def make_api_call(name, limit)
    HTTParty.get("#{@bubble_endpoint}/#{name}?limit=#{limit}&sort_field=Created%20Date&descending=true",
                 headers: { 'Authorization' => "Bearer #{ENV['BUBBLE_API_KEY']}" })
  end

  def extract_api_response(response)
    response['response']['results'][0].nil? ? { "error: table is empty": '_id' } : response['response']['results']
  end
end
