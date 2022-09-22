# frozen_string_literal: true

require_relative './data_type_checker'
require 'httparty'
require 'byebug'
require 'dotenv'

Dotenv.load

module BubbleRuby
  # class DbSchemaBuilder is responsible to create the schema based on the swagger documentation
  class DbSchemaBuilder
    include DataTypeChecker
    attr_reader :schema

    def initialize
      @schema = nil
      @table_names = nil
    end

    def fetch
      response = HTTParty.get(ENV['BUBBLE_SWAGGER_DOC_ENDPOINT'])
      JSON.parse(response)
    end

    def call
      res = fetch
      create_table_names(res)
      create_table_body(res)
      @schema.each { |table| table[:body]['bubble_id'] = table[:body].delete '_id' }
      @schema
    end

    def create_table_names(res)
      objs = res['paths'].select { |k, _v| k.match?(%r{/obj/(.*)/{UniqueID}}) }
      @table_names = objs.map { |k, _v| k.match(%r{/obj/(.*)/{UniqueID}}).captures }.flatten

      @schema = @table_names.map { |n| { name: n } }
    end

    def create_table_body(res)
      bodies = res['definitions'].select { |k, _v| @table_names.include?(k) }
      @schema.each do |table|
        bodies.each do |key, value|
          next unless table[:name].match?(/#{key}/)

          value['properties'].each do |key_prop, value_prop|
            table[:body] = {} if table[:body].nil?
            table[:body][key_prop] = check_data_type_and_return_postgre_type(value_prop)
          end
        end
      end
    end
  end
end
# objetivo é montar o schema da DB do bubble em postgresql

# resultado final é um array com várias hashes de cada table,
# em q temos {name: table_name, body: {column1: data_type1, column2: data_type2}}

# fazer um request para a documentação swagger q o bubble gerou

# vou pegar todos que estão em `paths` e tiveram /obj/ e salvar cada um dos nomes no table[:name]

# vou pegar cada um que está no `definitions` e correspondente ao nome do table[:name]
# vou abrir properties e iterar por cada um dos elementos e salvar no table[:body]
# preciso identificar o data_type e retornar como { column_name: data_type },
# olhando o type, se existe format, se tem $ref
# substituir o _id por bubble_id
