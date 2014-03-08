require 'spec_helper'

include Hiroshima5374

describe AreaDays::Parser do
  describe '#areas' do
    subject { AreaDays::Parser.new('中区', area_days_sample_html).areas }
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

    it 'big' do
      big = subject.first[8]
      expect(big).to eq('20130412 20130426 20130510 20130524 20130614 20130628 20130712 20130726 20130809 20130823 20130913 20130927 20131011 20131025 20131108 20131122 20131213 20131227 20140110 20140124 20140214 20140228 20140314 20140328 *1')
    end

    it 'unflammable' do
      unflammable = subject.first[9]
      expect(unflammable).to eq('金1 金3')
    end
  end
end
