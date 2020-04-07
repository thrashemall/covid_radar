RSpec.describe Country do
  describe '.by_iso2' do
    let!(:country) do
      create :country, iso2: 'US'
    end

    it 'works' do
      expect(described_class.by_iso2('US')).to contain_exactly(country)
      expect(described_class.by_iso2('us')).to contain_exactly(country)
      expect(described_class.by_iso2(' us ')).to contain_exactly(country)
      expect(described_class.by_iso2('fr')).to be_empty
    end
  end

  describe '#slug_url_safe' do
    context 'when bad' do
      subject  do
        build :country, slug: 'réunion us'
      end

      it 'works' do
        expect(subject.slug_url_safe).to eq('r%C3%A9union+us')
      end
    end

    context 'when ok' do
      subject  do
        build :country, slug: 'ascii'
      end

      it 'works' do
        expect(subject.slug_url_safe).to eq(subject.slug)
      end
    end
  end
end
