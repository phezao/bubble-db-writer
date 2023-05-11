# frozen_string_literal: true

module BubbleRuby
  require_relative '../table'
  require_relative '../table/column'
  module DB::Schema::Tables
    require_relative 'fetch'
    module Build
      extend self

      def call(endpoint:)
        response    = Fetch.call(endpoint: endpoint)
        table_names = extract_table_names(response)
        tables      = table_names.map { |name| DB::Schema::Table.new(name: name) }
        write_table_body(response, table_names, tables)
        tables
      end

      private

      def extract_table_names(response)
        objs = response['paths'].select { |k, _v| k.match?(%r{/obj/(.*)/{UniqueID}}) }
        objs.map { |k, _v| k.match(%r{/obj/(.*)/{UniqueID}}).captures }.flatten
      end

      def write_table_body(response, table_names, tables)
        bodies = response['definitions'].select { |k, _v| table_names.include?(k) }
        bodies.each do |key, value|
          table = find_table(tables, name: key)
          next unless table

          value['properties'].each do |key_prop, value_prop|
            column = BubbleRuby::DB::Schema::Table::Column.new(table: table.name, name: key_prop, type: value_prop)
            table.body << column
          end
        end
      end

      def find_table(tables, name:)
        tables.find { |table| table.name == name }
      end
    end
  end
end
