require 'dotenv'
require_relative 'lib/bubble_ruby'
# CU DATABASE FROM BUBBLE INTO POSTGRESQL
# C -> Create db from scratch
# Export db schema -> (json, ruby hash)
# U -> Update db with latest tables/records
Dotenv.load

db = BubbleRuby::DB.new(swagger_endpoint: ENV['BUBBLE_SWAGGER_DOC_ENDPOINT'])

db.create

db.update

# db.export(as: :json)
# db.export(as: :hash)
# db.import(filename)

db.migrate

db.seed

db.update_records

# Coesão
# Modularização
# Boas abstrações
# + Composição
# + Encapsulamento
# + Polimorfismo
# Encapsular o que varia
# Programar para interfaces não implementações
# Favorecer composição sobre herança
# Tell, don't ask
# Lei de demeter
# DRY
# Separação de responsibilidades
