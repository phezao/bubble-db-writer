# frozen_string_literal: true

require 'json'
require 'byebug'

module BubbleRuby
  class DB::Schema::Tables
    class Response
      attr_reader :table_names, :tables_response

      def initialize(data)
        @response = JSON.parse(data)
        self.table_names = extract_table_names
        self.tables_response = extract_table_response
      end

      private

      attr_writer :table_names, :tables_response

      def extract_table_response
        @response['definitions'] or raise ArgumentError
        @response['definitions'].select { |table_name, _v| table_names.include?(table_name) }
      end

      def extract_table_names
        @response['paths'] or raise ArgumentError
        objs = @response['paths'].select { |k, _v| k.match?(%r{/obj/(.*)/{UniqueID}}) }
        objs.map { |k, _v| k.match(%r{/obj/(.*)/{UniqueID}}).captures }.flatten
      end
    end
  end
end
