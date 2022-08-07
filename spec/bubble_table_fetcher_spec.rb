# frozen_string_literal: true

require_relative './../bubble_table_fetcher'

RSpec.describe BubbleTableFetcher do
  # describe '#make_api_call' do
  #   subject { described_class.new.make_api_call('ratings') }
  #   it 'is expected to return status code 200' do
  #     expect(subject.code).to be 200
  #   end
  # end

  describe '#analyze_response_data_types' do
    hash = {
      'Address (SEARCHBOX)' => { 'address' => 'R. da Feira 250, 4700 Braga, Portugal', 'lat' => 41.5562175,
                                 'lng' => -8.4352178 },
      'Company' => '1625820859739x819175157748203500',
      'CompanyType' => nil,
      'Date_Begin' => '2021-07-09T11:00:00.000Z',
      'Highlight' => false,
      'Lunch' => true,
      'Nhours' => 8,
      'NotVisibleTo' => [],
      'Shift_State' => 'Cancelled',
      'Shift_Range' => ['2021-07-09T11:00:00.000Z', '2021-07-09T19:00:00.000Z'],
      'shiftcandidates' => %w[1625820859739x819175157748203500 1625820859739x819175157748203643]
    }
    subject(:bubble_table_fetcher) { described_class.new }
    it 'shows us a hash' do
      puts bubble_table_fetcher.analyze_response_data_types(hash)
    end
  end
end
