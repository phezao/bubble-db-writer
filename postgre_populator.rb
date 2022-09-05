# frozen_string_literal: true

require 'json'
require './bubble_api_service'
require './pg_service'
require './tables_name_source'

# class PostgrePopulator
class PostgrePopulator
  def initialize(bubble_api_service, pg_service)
    @bubble_api_service = bubble_api_service
    @pg_service = pg_service
  end

  def call(table_name)
    remaining_counter = write_entries(table_name)

    return unless remaining_counter.positive?

    cursor = 101
    while remaining_counter.positive?
      remaining_counter = write_entries(table_name, cursor)
      cursor += 101
    end
  end

  def write_entries(table_name, cursor = 0)
    response = @bubble_api_service.call(table_name, 100, cursor)
    response['results'].each do |record|
      query = build_query(table_name, record)
      @pg_service.exec(query)
    end
    response['remaining']
  end

  def build_query(table_name, record)
    <<-SQL
      INSERT INTO \"#{table_name}\" (#{rename_id_to_bubble_id(record.keys).join(', ')})
      VALUES (#{convert_data(record.values).join(', ')})
    SQL
  end

  def rename_id_to_bubble_id(array)
    array[0..-2].push('bubble_id').map { |value| "\"#{value}\"" }
  end

  def convert_data(array)
    array.map do |value|
      check_data_type(value)
    end
  end

  def check_data_type(value)
    return value if value.instance_of?(Integer)
    return value if value.is_a?(TrueClass) || value.is_a?(FalseClass)
    return value if value.is_a?(Float)
    return "\'{#{value.join(', ')}}\'" if value.is_a?(Array)
    return "\'#{value.to_json.gsub(/'/, ' ')}\'" if value.is_a?(Hash) || value.nil?
    return "\'#{value}\'" if value.match?(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}.\d{3}Z/)
    return "\'#{value.gsub(/'/, ' ').gsub(/"/, '*')}\'" if value.match?(/\d{13}x\d{18}/) || value.instance_of?(String)
  end
end

# pg_service = PgService.new

# bubble_api_service = BubbleApiService.new

# populator = PostgrePopulator.new(bubble_api_service, pg_service)

# TABLE_NAMES.each do |table_name|
#   populator.call(table_name)
# end
