# frozen_string_literal: true

require 'bubble_ruby/postgre_data_updater'

module BubbleRuby
  RSpec.describe PostgreDataUpdater do
    let(:bubble_api_service) { double }
    let(:updater) { described_class.new(bubble_api_service) }
    describe '#convert_postgre_value' do
      it 'converts the postgre value to the oringinal value from bubble' do
        expect(updater.send(:convert_postgre_value, 18, '18')).to eq(18)
        expect(updater.send(:convert_postgre_value, true, 't')).to be_truthy
        expect(updater.send(:convert_postgre_value, false, 'f')).to be_falsy
        expect(updater.send(:convert_postgre_value, 11.5, '11.5')).to eq(11.5)
        expect(updater.send(:convert_postgre_value, ['2022-10-03T07:35:00.000Z', '2022-10-03T18:25:00.000Z'],
                            '{2022-10-03T07:35:00.000Z,2022-10-03T18:25:00.000Z}')).to eq(['2022-10-03T07:35:00.000Z',
                                                                                           '2022-10-03T18:25:00.000Z'])
        expect(updater.send(:convert_postgre_value,
                            { 'address' => 'R. Ary dos Santos 11, 2925-061 Azeitão, Portugal', 'lat' => 38.54677, 'lng' => -9.0292118 }, '{"address":"R. Ary dos Santos 11, 2925-061 Azeitão, Portugal","lat":38.54677,"lng":-9.0292118}')).to eq({
                                                                                                                                                                                                                                                    'address' => 'R. Ary dos Santos 11, 2925-061 Azeitão, Portugal', 'lat' => 38.54677, 'lng' => -9.0292118
                                                                                                                                                                                                                                                  })
        expect(updater.send(:convert_postgre_value, nil, nil)).to be_nil
        expect(updater.send(:convert_postgre_value, '2022-09-28T15:56:15.233Z',
                            '2022-09-28 15:56:15.233+00')).to be_a(DateTime)
      end
    end

    describe '#analyze_data_with_bubble' do
      context 'when the key is id' do
        it 'goes to the next record' do
          bubble_data = {
            '_id' => '1928475983946x817392873849284727'
          }

          data = {
            'bubble_id' => '1928475983946x817392873849284727'
          }

          allow(updater).to receive(:execute_query).and_return('updated query executed!')

          expect(updater).not_to receive(:execute_query)

          updater.send(:analyze_data_with_bubble, bubble_data, 'rating', '1928475983946x817392873849284727', data)
        end
      end

      context 'when the value of the bubble_record is equal to the value in the db' do
        it 'goes to the next record' do
          bubble_data = {
            '_id' => '1928475983946x817392873849284727',
            'state' => 'On going'
          }

          data = {
            'state' => 'On going'
          }
          allow(updater).to receive(:execute_query).and_return('updated query executed!')

          expect(updater).not_to receive(:execute_query)

          updater.send(:analyze_data_with_bubble, bubble_data, 'rating', '1928475983946x817392873849284727', data)
        end
      end

      context 'when the value of the bubble_record differs from the value in the db' do
        it 'executes the update query in the db' do
          bubble_data = {
            '_id' => '1928475983946x817392873849284727',
            'state' => 'On going'
          }

          data = {
            'state' => 'Confirmed'
          }

          allow(updater).to receive(:execute_query).and_return('updated query executed!')

          expect(updater).to receive(:execute_query)

          updater.send(:analyze_data_with_bubble, bubble_data, 'rating', '1928475983946x817392873849284727', data)
        end
      end
    end
  end
end
