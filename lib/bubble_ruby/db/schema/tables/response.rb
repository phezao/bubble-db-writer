# frozen_string_literal: true

module BubbleRuby
  class DB::Schema::Tables
    class Response
      attr_accessor :table_names, :tables_response

      def initialize(endpoint:)
        @response = Fetch.call(endpoint: endpoint)
        self.table_names = extract_table_names
        self.tables_response = extract_table_response
      end

      private

      def extract_table_response
        @response['definitions'].select { |table_name, _v| table_names.include?(table_name) }
      end

      def extract_table_names
        objs = @response['paths'].select { |k, _v| k.match?(%r{/obj/(.*)/{UniqueID}}) }
        objs.map { |k, _v| k.match(%r{/obj/(.*)/{UniqueID}}).captures }.flatten
      end
    end
  end
end
