# frozen_string_literal: true

require_relative 'query_builder'
require_relative 'data_type_checker'
require 'byebug'

module BubbleRuby
  # class PostgreDataUpdater is responsible to update the data from each table if there was any modification. The optional argument (limit) allows you to limit the number of records you want to update
  class PostgreDataUpdater
    include QueryBuilder
    include DataTypeChecker

    def initialize(bubble_api_service)
      @bubble_api_service = bubble_api_service
    end

    def call(table_name, limit = nil)
      message = limit.nil? ? "Fetching all #{table_name} records from db..." : "Fetching #{limit} records from #{table_name} in the db..."
      puts message
      query = build_query(limit, table_name)
      res = execute_query(query)

      puts 'Going through the records...'
      res.each_with_index do |data, i|
        puts "Progress: #{i + 1} / #{res.ntuples} | bubble_id => #{data['bubble_id']}"
        bubble_data = fetch_bubble_record(table_name, data['bubble_id'])
        analyze_data_with_bubble(bubble_data, table_name, data['bubble_id'], data) if bubble_data
      end
    end

    private

    def fetch_bubble_record(table_name, bubble_id)
      @bubble_api_service.fetch_single_record(table_name, bubble_id)['response']
    end

    def build_query(limit, table_name)
      if limit.nil?
        build_fetch_records_from_db_desc_query(table_name)
      else
        build_fetch_numbered_records_from_db_desc_query(table_name, limit)
      end
    end

    def analyze_data_with_bubble(bubble_data, table_name, bubble_id, data)
      data.each do |key, value|
        next if key.match?(/id/)

        converted_value = check_data_type_and_return_converted_value(bubble_data[key], value)
        next if converted_value.is_a?(DateTime) && (DateTime.parse(bubble_data[key]) == converted_value)
        next unless bubble_data[key] != converted_value

        puts 'Updating value! 🔧'
        column_value = format_column_value(bubble_data[key], table_name, key)
        unless column_value.instance_of?(Integer) || column_value.is_a?(TrueClass) || column_value.is_a?(FalseClass) || column_value.is_a?(Float) || bubble_data[key].is_a?(Hash)
          column_value = column_value.gsub('"', '').gsub("'", '')
        end

        execute_query(build_update_record_query(table_name, key, column_value,
                                                bubble_id, bubble_data[key]))
      end
    end

    def format_column_value(bubble_data, table_name, column_name)
      if bubble_data.nil?
        check_column_type_and_return_null_type(column_name, table_name)
      else
        check_data_type_and_return_formatted_value(bubble_data)
      end
    end

    def check_column_type_and_return_null_type(column_name, table_name)
      query = build_check_column_names_query(table_name)
      res = execute_query(query)

      type = res.select { |column| column['column_name'] == column_name }.first
      return 0 if type['data_type'] == 'double precision'

      'null'
    end
  end
end
