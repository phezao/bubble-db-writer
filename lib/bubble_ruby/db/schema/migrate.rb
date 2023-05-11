# frozen_string_literal: true

require_relative 'tables/check'

module BubbleRuby::DB
  module Schema::Migrate
    extend self

    def call(schema, middleware)
      schema.is_a?(Schema) or raise TypeError
      middleware.is_a?(Middleware) or raise TypeError

      pg_table_names = middleware.execute(Schema::Tables::Check.call).column_values(0)
      schema.tables.each do |table|
        return middleware.execute(table.create_query) unless pg_table_names.include?(table.name)

        verify_table_columns(table)
      end
    end

    private

    def verify_table_columns(table)
      pg_columns = middleware.execute(Schema::Table::Column::Check.call(table)).column_values(3)
      table.body.each do |table_column|
        table_column.create_query unless pg_columns.include?(table_column.name)
      end
    end
  end
end
