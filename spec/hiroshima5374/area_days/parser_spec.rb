require 'spec_helper'

include Hiroshima5374::AreaDays

describe Parser do
  describe '#areas' do
    subject { Parser.new(sample_html).areas }
    it('10 rows') { expect(subject.size).to eq(10) }
    it '10x10' do
      counts = subject.map do |area|
        area.count
      end
      expect(counts.reduce(:+)).to eq(100)
    end

    it 'flammable' do
      flammbale = subject.first[2]
      expect(flammbale).to eq('月 木')
    end
  end
end
