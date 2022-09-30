# frozen_string_literal: true

require 'httparty'
require 'dotenv'

Dotenv.load

module BubbleRuby
  # class BubbleRuby::BubbleApiService is responsible to retrive records from bubble
  class BubbleApiService
    def initialize
      @bubble_endpoint = ENV['API_ENDPOINT']
    end

    def fetch_records(name, limit = 1, cursor = 0)
      extract_api_response(fetch_records_api_call(name, limit, cursor))
    end

    def fetch_single_record(name, bubble_id)
      fetch_single_record_api_call(name, bubble_id)
    end

    private

    def fetch_records_api_call(name, limit = 1, cursor = 0)
      HTTParty.get("#{@bubble_endpoint}/#{name.downcase.gsub(' ', '')}?limit=#{limit}&cursor=#{cursor}&sort_field=Created%20Date&descending=true",
                   headers: { 'Authorization' => "Bearer #{ENV['BUBBLE_API_KEY']}" })
    end

    def fetch_single_record_api_call(name, bubble_id)
      HTTParty.get("#{@bubble_endpoint}/#{name.downcase.gsub(' ', '')}/#{bubble_id}",
                   headers: { 'Authorization' => "Bearer #{ENV['BUBBLE_API_KEY']}" })
    end

    def extract_api_response(response)
      response['response']['results'][0].nil? ? { 'results' => [{ "error: table is empty": '_id' }] }.transform_keys(&:to_s) : response['response']
    end
  end
end
