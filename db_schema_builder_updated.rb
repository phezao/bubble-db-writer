# frozen_string_literal: true

require 'httparty'
require 'byebug'

class DbSchemaBuilderUpdated
  def initialize
    @schema = nil
    @table_names = nil
  end

  def fetch
    response = HTTParty.get('https://app.mycareforce.co/version-test/api/1.1/meta/swagger.json')
    JSON.parse(response)
  end

  def call
    res = fetch
    create_table_names(res)
    create_table_body(res)
    @schema.each { |table| table[:body][:bubble_id] = table[:body].delete '_id' }
    @schema
    byebug
  end

  def check_type(value)
    return 'JSON' if value.keys.include?('$ref')
    return 'TIMESTAMPTZ' if value.keys.include?('format') && value['format'] == 'date-time'
    return 'TEXT' if value['type'] == 'string'
    return 'FLOAT8' if value['type'] == 'number'
    return 'BOOLEAN' if value['type'] == 'boolean'
    return 'TEXT ARRAY' if value['type'] == 'array'
  end

  def create_table_names(res)
    objs = res['paths'].select { |k, _v| k.match?(%r{/obj/(.*)/{UniqueID}}) }
    @table_names = objs.map { |k, _v| k.match(%r{/obj/(.*)/{UniqueID}}).captures }.flatten

    @schema = @table_names.map { |n| { name: n } }
  end

  def create_table_body(res)
    bodies = res['definitions'].select { |k, _v| @table_names.include?(k) }
    @schema.each do |table|
      bodies.each do |k, v|
        next unless table[:name].match?(/#{k}/)

        v['properties'].each do |key, value|
          table[:body][:"#{key}"] = check_type(value)
        end
      end
    end
  end
end

# DbSchemaBuilderUpdated.new.call
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
