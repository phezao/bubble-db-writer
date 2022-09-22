# frozen_string_literal: true

require 'json'
require 'byebug'
require_relative './bubble_api_service'
require_relative './data_type_checker'
require_relative 'query_builder'

module BubbleRuby
  # class PostgrePopulator is responsible to populate the latest records from bubble until the last imported record.
  class PostgrePopulator
    include BubbleRuby::QueryBuilder
    include DataTypeChecker
    def initialize(bubble_api_service)
      @bubble_api_service = bubble_api_service
    end

    def call(table_name)
      puts 'Checking if there are new records to write'
      db_record = fetch_last_record_from_db(table_name)
      remaining_counter = write_entries(table_name, db_record)

      return unless !remaining_counter.nil? && remaining_counter.positive?

      cursor = 101
      while remaining_counter.positive?
        puts 'Writing new entries...'
        remaining_counter = write_entries(table_name, db_record, cursor)
        cursor += 101
      end
    end

    private

    def fetch_last_record_from_db(table_name)
      res = execute_query(build_fetch_last_record_from_db_query(table_name))
      res.ntuples.positive? ? res.tuple(0) : nil
    end

    def fetch_records_from_bubble(table_name, cursor)
      @bubble_api_service.call(table_name, 100, cursor)
    end

    def populate_db(bubble_record, table_name)
      query = build_insert_data_query(table_name, bubble_record)
      execute_query(query)
    end

    def write_entries(table_name, db_record, cursor = 0)
      response = fetch_records_from_bubble(table_name, cursor)
      response['results'].each do |bubble_record|
        bubble_record.reject! { |k, _v| k == 'SignUpState' }
        if db_record.nil? || (bubble_record['_id'] != db_record['bubble_id'])
          populate_db(bubble_record,
                      table_name)
          next
        end

        return 0
      end
      response['remaining']
    end

    def rename_id_to_bubble_id(array)
      array[0..-2].push('bubble_id').map { |value| "\"#{value}\"" }
    end

    def convert_data(array)
      array.map do |value|
        check_data_type_and_return_formatted_value(value)
      end
    end
  end
end

# 1. Buscar a última entrada escrita na DB do Postgre (bubble_id) e salvar esse bubble_id
# 2. Fazer fetch no bubble de 100 em 100 e até encontrar o bubble_id salvo
# 3. Quando encontrar o bubble_id salvo, importar os dados seguintes a esse record

# eu preciso saber qual o último record importado na base de dados,
# olhar pelo Created Date e guardar as informações como bubble_id que vai ser
# utilizado para fazer fetch.

# Fazer fetch por ordem decrescente dos últimos records e ir importando
# até record dar match entre o id dele e o id que temos na base de dados
