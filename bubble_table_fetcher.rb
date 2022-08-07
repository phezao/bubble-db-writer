# frozen_string_literal: true

require 'httparty'
require 'dotenv'

Dotenv.load

# class BubbleTableFetcher
class BubbleTableFetcher
  attr_reader :body

  def initialize
    @bubble_endpoint = ENV['API_ENDPOINT']
  end

  def call(name)
    response = make_api_call(name)
    analyze_response_data_types(extract_api_response(response))
  end

  private

  def make_api_call(name)
    HTTParty.get("#{@bubble_endpoint}/#{name}?limit=1",
                 headers: { 'Authorization' => "Bearer #{ENV['BUBBLE_API_KEY']}" })
  end

  def extract_api_response(response)
    response['response']['results'][0].nil? ? { "error: #{response}": '_id' } : response['response']['results'][0]
  end

  def analyze_response_data_types(response)
    response_data_type = {}
    response.each { |key, value| response_data_type[key] = check_data_type(value) }
    response_data_type
  end

  def check_data_type(value)
    return 'INT' if value.instance_of?(Integer)
    return 'BOOLEAN' if value.is_a?(TrueClass) || value.is_a?(FalseClass)
    return 'FLOAT8' if value.is_a?(Float)
    return 'TEXT ARRAY' if value.is_a?(Array)
    return 'TEXT' if value.is_a?(Hash) || value.nil?
    return 'DATE' if value.match?(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}.\d{3}Z/)
    return 'TEXT' if value.match?(/\d{13}x\d{18}/) || value.instance_of?(String)
  end
end
