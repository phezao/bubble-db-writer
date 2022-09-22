# frozen_string_literal: true

# class SchemaRefiner is responsible to update the postgre db schema based by fetching records from Bubble
class SchemaRefiner
  def initialize(table_names, bubble_api_service, pg_service, schema)
    @table_names = table_names
    @bubble_api_service = bubble_api_service
    @pg_service = pg_service
    @schema = schema
  end

  def call
    @table_names.each do |table_name|
      schema = find_schema(table_name)
      response = fetch(table_name)
      response['results'].each do |record|
        compare_record(record, schema, table_name)
      end
    end
    @schema
  end

  def fetch(table_name)
    @bubble_api_service.call(table_name, 100)['results']
  end

  def compare_record(record, schema, table_name)
    record.map do |name, value|
      next if schema.key?(name) || name == '_id'

      update_schema(name, value, schema)
      query = build_query(table_name, name, value)
      @pg_service.exec(query)
    end.compact
  end

  def build_query(table_name, name, value)
    data_type = check_data_type(value)
    <<-SQL
      ALTER TABLE \"#{table_name}\"
      ADD COLUMN \"#{name}\" #{data_type};
    SQL
  end

  def update_schema(name, value, schema)
    schema[name.to_s] = check_data_type(value)
  end

  def find_schema(table_name)
    @schema.select { |table| table[:name] == table_name }.first[:body]
  end

  def check_data_type(value)
    return 'INT' if value.instance_of?(Integer)
    return 'BOOLEAN' if value.is_a?(TrueClass) || value.is_a?(FalseClass)
    return 'FLOAT8' if value.is_a?(Float)
    return 'TEXT ARRAY' if value.is_a?(Array)
    return 'JSON' if value.is_a?(Hash) || value.nil?
    return 'TIMESTAMPTZ' if value.match?(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}.\d{3}Z/)
    return 'TEXT' if value.match?(/\d{13}x\d{18}/) || value.instance_of?(String)
  end
end
