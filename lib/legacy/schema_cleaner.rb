# frozen_string_literal: true

# class SchemaCleaner
class SchemaCleaner
  def initialize(schema)
    @schema = schema
  end

  def clean
    @schema = @schema.reject { |table| table[:body].key?(:"error: table is empty") }
    @schema.each { |table| table[:body][:bubble_id] = table[:body].delete '_id' }
    File.write('schema.rb', @schema)
  end
end
