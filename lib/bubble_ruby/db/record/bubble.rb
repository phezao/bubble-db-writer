# frozen_string_literal: true

module BubbleRuby
  class DB::Record::Bubble
    attr_reader :table_name, :bubble_id, :data

    def initialize(table_name:, bubble_id:)
      self.table_name = table_name
      self.bubble_id = bubble_id
      self.data = fetch_record(table_name, bubble_id)
    end

    private

    def fetch_record
      request = HTTParty.get("#{@bubble_endpoint}/#{table_name.downcase.gsub(' ', '')}/#{bubble_id}",
                             headers: { 'Authorization' => "Bearer #{ENV['BUBBLE_API_KEY']}" })

      request['response']
    end
  end
end
