# frozen_string_literal: true

require 'legacy/bubble_table_fetcher'

RSpec.describe BubbleTableFetcher do
  before do
    @bubble_api_service = double
    hash = {
      'Address (SEARCHBOX)' => { 'address' => 'R. da Feira 250, 4700 Braga, Portugal', 'lat' => 41.5562175,
                                 'lng' => -8.4352178 }, # JSON
      'Company' => '1625820859739x819175157748203500', # TEXT
      'CompanyType' => nil, # TEXT
      'Date_Begin' => '2021-07-09T11:00:00.000Z', # TIMESTAMPTZ
      'Highlight' => false, # BOOLEAN
      'Lunch' => true, # BOOLEAN
      'Nhours' => 8, # INT
      'Value' => 12.3, # FLOAT8
      'NotVisibleTo' => [], # TEXT ARRAY
      'Shift_State' => 'Cancelled', # TEXT
      'Shift_Range' => ['2021-07-09T11:00:00.000Z', '2021-07-09T19:00:00.000Z'], # TEXT ARRAY
      'shiftcandidates' => %w[1625820859739x819175157748203500 1625820859739x819175157748203643] # TEXT ARRAY
    }
    response = { "results": [hash] }.transform_keys(&:to_s)
    allow(@bubble_api_service).to receive(:call).and_return(response)
  end

  let(:bubble_table_fetcher) { described_class.new(@bubble_api_service).call('Shift') }
  describe '#call' do
    xit 'returns the correct data type corresponded to the value of the column' do
      expect(bubble_table_fetcher['Address (SEARCHBOX)']).to eql('JSON')
      expect(bubble_table_fetcher['Company']).to eql('TEXT')
      expect(bubble_table_fetcher['CompanyType']).to eql('TEXT')
      expect(bubble_table_fetcher['Date_Begin']).to eql('TIMESTAMPTZ')
      expect(bubble_table_fetcher['Highlight']).to eql('BOOLEAN')
      expect(bubble_table_fetcher['Lunch']).to eql('BOOLEAN')
      expect(bubble_table_fetcher['Nhours']).to eql('INT')
      expect(bubble_table_fetcher['Value']).to eql('FLOAT8')
      expect(bubble_table_fetcher['NotVisibleTo']).to eql('TEXT ARRAY')
      expect(bubble_table_fetcher['Shift_State']).to eql('TEXT')
      expect(bubble_table_fetcher['Shift_Range']).to eql('TEXT ARRAY')
      expect(bubble_table_fetcher['shiftcandidates']).to eql('TEXT ARRAY')
    end

    xit 'returns a hash with keys as the table columns and values as the data type' do
      expect(bubble_table_fetcher).to be_a(Hash)
      expect(bubble_table_fetcher).not_to be_empty
    end
  end
end
