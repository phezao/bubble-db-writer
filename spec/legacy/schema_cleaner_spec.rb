# frozen_string_literal: true

require 'legacy/schema_cleaner'

RSpec.describe SchemaCleaner do
  describe '#clean' do
    xit 'returns the schema without the empty tables' do
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
      clean_schema = described_class.new(schema).clean
      expect(clean_schema.length).to be 1
    end
    xit 'substitutes the _id to bubble_id' do
      schema = [
        { name: 'Ratings',
          body: { 'Rating' => 'INT', 'Shift' => 'TEXT', 'Created By' => 'TEXT', 'Created Date' => 'DATE',
                  'Modified Date' => 'DATE', 'Company' => 'TEXT', 'User' => 'TEXT', '_id' => 'TEXT' } }, { name: 'Account', body: { 'Registered' => 'BOOLEAN', 'CompanyService' => 'TEXT', 'User' => 'TEXT', 'Created By' => 'TEXT', 'Modified Date' => 'DATE', 'Created Date' => 'DATE', 'Company' => 'TEXT', '_id' => 'TEXT' } }
      ]
      clean_schema = described_class.new(schema).clean
      expect(clean_schema.first[:body].key?(:bubble_id)).to be_truthy
      expect(clean_schema.first[:body].key?(:_id)).to be_falsy
    end
    xit 'updates the schema.rb file in the directory'
  end
end
