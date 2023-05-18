# frozen_string_literal: true

require 'byebug'

module BubbleRuby::DB
  class Records::Update
    def initialize(middleware:)
      @middleware = middleware
    end

    def call(table_name, limit = nil)
      query = Records::FetchQuery.call(table_name: table_name, limit: limit)
      response = middleware.execute(query)

      response.each do |data|
        bubble = Record::Bubble.new(table_name: table_name, bubble_id: data['bubble_id'])
        analyze_data_with_bubble(bubble, data) if bubble.data
      end
    end

    private

    def analyze_data_with_bubble(bubble, pg_data)
      pg_data.each do |column_name, column_value|
        next if column_name.match?(/id/)
        next if bubble[column_name].matches(column_value)

        column = Record::Column.new(bubble_data: bubble[column_name], table_name: bubble.table_name,
                                    column_name: column_name)
        record = Record.new(column: column, bubble_id: bubble.id, bubble_data_type: bubble_data[column_name])

        @middleware.execute(Record::UpdateQuery.call(record))
      end
    end
  end
end
