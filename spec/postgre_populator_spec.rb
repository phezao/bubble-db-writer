# frozen_string_literal: true

require_relative './../postgre_populator'

RSpec.describe PostgrePopulator do
  describe '#write_entries' do
    it 'returns the remaining number of entries' do
      bubble_api_service = double
      allow(bubble_api_service).to receive(:call).and_return({ results: [1, 2, 3],
                                                               remaining: 300 }.transform_keys(&:to_s))
      pg_service = double
      allow(pg_service).to receive(:exec)
      populator = described_class.new(bubble_api_service, pg_service)
      allow(populator).to receive(:build_query)

      expect(populator.write_entries('Nurse')).to eq(300)
    end
  end

  describe '#build_query' do
    it 'returns an SQL query to insert the data to the table' do
      bubble_api_service = double
      pg_service = double
      populator = described_class.new(bubble_api_service, pg_service)

      record = { Nome: 'Felipe', Idade: 18, _id: '19823493703757x1982349370375705837' }
      query = populator.build_query('Nurse', record)

      expected_query = <<-SQL
      INSERT INTO \"Nurse\" ("Nome", "Idade", "bubble_id")
      VALUES ('Felipe', 18, '19823493703757x1982349370375705837')
      SQL

      expect(query.split).to eq(expected_query.split)
    end
  end

  describe '#rename_id_to_bubble_id' do
    it 'returns the record with bubble_id instead of _id' do
      bubble_api_service = double
      pg_service = double
      populator = described_class.new(bubble_api_service, pg_service)
      record = { Nome: 'Felipe', Idade: 18, _id: '19823493703757x1982349370375705837' }

      expect(populator.rename_id_to_bubble_id(record.keys)).to include('"bubble_id"')
    end
  end

  describe '#convert_data' do
    it 'iterates through all the elements and executes the #check_data_type' do
      bubble_api_service = double
      pg_service = double
      populator = described_class.new(bubble_api_service, pg_service)
      record = { Nome: 'Felipe', Idade: 18, _id: '19823493703757x1982349370375705837' }
      allow(populator).to receive(:check_data_type).and_return('Executing #check_data_type')

      expect(populator.convert_data(record.values)).to all(eq('Executing #check_data_type'))
    end
  end

  describe '#check_data_type' do
    it 'returns the correct format of the value depending of the data type' do
      bubble_api_service = double
      pg_service = double
      populator = described_class.new(bubble_api_service, pg_service)
      record = { Nome: 'Felipe', Idade: 18, _id: '19823493703757x1982349370375705837' }

      expect(populator.check_data_type(record.values.first)).to eq("'Felipe'")
    end
  end

  describe '#call' do
    context 'when write_entries returns a positive integer of remaining entries' do
      it 'keeps looping until write_entries returns 0' do
        bubble_api_service = double
        pg_service = double
        populator = described_class.new(bubble_api_service, pg_service)
        allow(populator).to receive(:write_entries).and_return(505, 404, 303, 202, 101, 0)

        expect(populator.call('test')).to eq(nil)
      end
    end

    context 'when write_entries returns 0 of remaining entries' do
      it 'stops the execution' do
        bubble_api_service = double
        pg_service = double
        populator = described_class.new(bubble_api_service, pg_service)
        allow(populator).to receive(:write_entries).and_return(0)

        expect(populator.call('test')).to eq(nil)
      end
    end
  end
end
