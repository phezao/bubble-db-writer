# frozen_string_literal: true

require_relative './bubble_api_service'
require_relative 'query_builder'
require 'byebug'

module BubbleRuby
  # class TableSingleAssociator is responsible to create associations 1-to-1 and 1-to-many checking for fields that have a bubble_id
  class TableSingleAssociator
    include BubbleRuby::QueryBuilder
    attr_reader :queries

    def initialize(table_names)
      @table_names = table_names
      @queries = []
    end

    def call(table_name)
      puts 'Checking relationships between tables'
      text_columns = get_string_columns(table_name)
      text_columns.each do |tuple|
        record = check_record(table_name, tuple['column_name'])
        bubble_id_matcher(table_name, record) if record
      end
      @queries
    end

    private

    def get_string_columns(table_name)
      query = build_check_column_names_query(table_name)
      res = execute_query(query).map(&:to_h)
      res.select { |tuple| tuple['data_type'] = 'text' }
    end

    def bubble_id_matcher(table, record)
      record.map do |key, value|
        next unless value && bubble_id?(value, key) && !foreign_key?(record, key)

        insert_foreign_key(table, key)
      end
    end

    def insert_foreign_key(table, column)
      puts 'Creating relationship'
      query = build_create_foreign_key_query(table, column)
      @queries << query
      execute_query(query)
    end

    def bubble_id?(value, key)
      value.match?(/\A\d{13}x\d{18}\z/) && key != 'Created By' && key != 'bubble_id' && @table_names.include?(key)
    end

    def foreign_key?(record, key)
      record.key?("#{key.gsub(' ', '').downcase}_id")
    end

    def check_record(table_name, column_name)
      query = build_check_record_query(table_name, column_name)
      res = execute_query(query)
      res.ntuples.positive? ? res.tuple(0) : nil
    end
  end
end

# vai listar todas as colunas da table e com o tipo, vai pegar todas que são TEXT
# Vai executar uma query q retorne um record em que a coluna não está empty
# Se o record com a coluna indicada for um bubble_id e não existir um foreign_key associada a ele e ele tiver uma table
# Criar foreign_key
# Se o record com a coluna indicada não tiver bubble_id ou existir foreign_key ou não existir table dessa coluna então ir para a próxima coluna
