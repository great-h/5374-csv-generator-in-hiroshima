require 'spec_helper'

include Hiroshima5374::AreaDays

describe Parser do
  describe '#areas' do
    subject { Parser.new('中区', sample_html).areas }
    it('10 rows') { expect(subject.size).to eq(10) }
    it '10x10' do
      counts = subject.map do |area|
        area.count
      end
      expect(counts.reduce(:+)).to eq(100)
    end

    it 'area' do
      flammbale = subject.first[0]
      expect(flammbale).to eq('中区 舟入南2丁目、3丁目、6丁目 西川口町')
    end

    it 'flammable' do
      flammbale = subject.first[2]
      expect(flammbale).to eq('月 木')
    end

    it 'petbottle' do
      petbottle = subject.first[3]
      expect(petbottle).to eq('火')
    end

    it 'resource' do
      resource = subject.first[5]
      expect(resource).to eq('水2 水4')
    end

    it 'etc' do
      etc = subject.first[7]
      expect(etc).to eq('水1 水3')
    end
  end
end
