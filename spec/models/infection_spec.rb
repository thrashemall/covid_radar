RSpec.describe Infection do
  describe '#summary' do
    context 'when data do exists' do
      subject do
        build :infection, confirmed: 1, confirmed_delta: 2, confirmed_rate: 3.0,
              deaths: 4_000, deaths_delta: 5_000, deaths_rate: 6,
              recovered: 7, recovered_delta: -8, recovered_rate: -9
      end

      it 'works' do
        expect(subject.summary).to include("Confirmed: 1 (+2 / +3%)")
        expect(subject.summary).to include("Deaths: 4 000 (+5 000 / +6%)")
        expect(subject.summary).to include("Recovered: 7 (-8 / -9%)")
      end
    end

    context 'when data not exists' do
      subject do
        build :infection, confirmed: nil, confirmed_delta: nil, confirmed_rate: nil,
              deaths: nil, deaths_delta: nil, deaths_rate: nil,
              recovered: nil, recovered_delta: nil, recovered_rate: nil
      end

      it 'works' do
        expect(subject.summary).to include("Confirmed: 0 (0 / 0%)")
        expect(subject.summary).to include("Deaths: 0 (0 / 0%)")
        expect(subject.summary).to include("Recovered: 0 (0 / 0%)")
      end
    end
  end
end
