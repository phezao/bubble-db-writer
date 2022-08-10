# frozen_string_literal: true

require_relative './../schema_cleaner'

RSpec.describe SchemaCleaner do
  describe '#clean' do
    it 'returns the schema without the empty tables' do
      schema = [
        {
          name: 'Example',
          body: {
            "_id": 'TEXT'
          }
        },
        {
          name: 'Empty',
          body: {
            "error: table is empty": 'TEXT',
            "_id": 'TEXT'
          }
        }
      ]
      clean_schema = SchemaCleaner.new(schema).clean
      expect(clean_schema.length).to be 1
    end
    it 'substitutes the _id to bubble_id' do
      schema = [
        { name: 'Ratings',
          body: { 'Rating' => 'INT', 'Shift' => 'TEXT', 'Created By' => 'TEXT', 'Created Date' => 'DATE',
                  'Modified Date' => 'DATE', 'Company' => 'TEXT', 'User' => 'TEXT', '_id' => 'TEXT' } }, { name: 'Account', body: { 'Registered' => 'BOOLEAN', 'CompanyService' => 'TEXT', 'User' => 'TEXT', 'Created By' => 'TEXT', 'Modified Date' => 'DATE', 'Created Date' => 'DATE', 'Company' => 'TEXT', '_id' => 'TEXT' } }
      ]
      clean_schema = SchemaCleaner.new(schema).clean
      expect(clean_schema.first[:body].key?(:bubble_id)).to be_truthy
      expect(clean_schema.first[:body].key?(:_id)).to be_falsy
    end
    it 'updates the schema.rb file in the directory'
  end
end
