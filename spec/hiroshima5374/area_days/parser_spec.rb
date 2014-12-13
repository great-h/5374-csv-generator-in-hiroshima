require 'spec_helper'

include Hiroshima5374

describe AreaDays::Parser do
  describe '#areas' do
    subject { AreaDays::Parser.new('中区', area_days_sample_html).areas }
    it('10 rows') { expect(subject.size).to eq(10) }
    it '14x10' do
      counts = subject.map do |area|
        area.count
      end
      expect(counts.reduce(:+)).to eq(140)
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
      text = resource[0..1].join(" ")
      expect(text).to eq('20140410 20140424')
    end

    it 'resource_display' do
      resource = subject.first[5]
      expect(resource).to eq('水2 水4')
    end

    it 'etc' do
      etc = subject.first[7]
      text = text[0..1].join(" ")
      expect(text).to eq('20140403 20140417')
    end

    it 'etc_disploy' do
      etc = subject.first[7]
      expect(etc).to eq('水1 水3')
    end

    it 'big' do
      big = subject.first[8]
      expect(big).to eq('20140412 20140426 20140510 20140524 20140614 20140628 20140712 20140726 20140809 20140823 20140913 20140927 20141011 20141025 20141108 20141122 20141213 20141227 20150110 20150124 20150214 20150228 20150314 20150328 *1')
    end

    it 'unflammable' do
      unflammable = subject.first[9]
      text = unflammable[0..1].join(" ")
      expect(unflammable).to eq('20140405 20140419')
    end

    it 'unflammable_display' do
      unflammable = subject.first[9]
      expect(unflammable).to eq('金1 金3')
    end
  end
end
