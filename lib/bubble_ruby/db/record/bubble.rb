# frozen_string_literal: true

module BubbleRuby
  class DB::Record::Bubble
    require_relative 'bubble/data_point'

    attr_reader :table_name, :id, :data

    def initialize(table_name:, bubble_id:)
      self.table_name = table_name
      self.id = bubble_id
      self.data = fetch_record
    end

    private

    def fetch_record
      request = HTTParty.get("#{@bubble_endpoint}/#{table_name.downcase.gsub(' ', '')}/#{bubble_id}",
                             headers: { 'Authorization' => "Bearer #{ENV['BUBBLE_API_KEY']}" })

      request['response']
    end

    def data_points
      data.map do |column_name, column_value|
        Bubble::DataPoint.new(column_name: column_name, column_value: column_value)
      end
    end

    def [](column_name)
      data_points.find { |data| data.column_name == column_name }
    end
  end
end
