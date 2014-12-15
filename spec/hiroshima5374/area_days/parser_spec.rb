require 'spec_helper'

include Hiroshima5374

describe AreaDays::Parser do
  describe '#areas' do
    subject { AreaDays::Parser.new('中区', area_days_sample_html).areas }
    it('10 rows') { expect(subject.size).to eq(10) }

    it 'area' do
      flammbale = subject[0].area
      expect(flammbale).to eq('中区 舟入南2丁目、3丁目、6丁目 西川口町')
    end

    it 'flammable' do
      flammbale = subject[0].flammable
      expect(flammbale).to eq('月 木')
    end

    it 'petbottle' do
      petbottle = subject[0].petbottle
      expect(petbottle).to eq('火')
    end

    it 'resource' do
      resource = subject[0].resource
      expect(resource).to eq(["20140410", "20140424", "20140508", "20140522", "20140612", "20140626", "20140710", "20140724", "20140814", "20140828", "20140911", "20140925", "20141009", "20141023", "20141113", "20141127", "20141211", "20141225", "20140108", "20140122", "20140212", "20140226", "20140312", "20140326"])
    end

    it 'resource_display' do
      resource = subject[0].resource_display
      expect(resource).to eq('水2 水4')
    end

    it 'etc' do
      etc = subject[0].etc
      expect(etc).to eq(["20140403", "20140417", "20140501", "20140515", "20140605", "20140619", "20140703", "20140717", "20140807", "20140821", "20140904", "20140918", "20141002", "20141016", "20141106", "20141120", "20141204", "20141218", "20140115", "20140124", "20140205", "20140219", "20140305", "20140319"])
    end

    it 'etc_disploy' do
      etc = subject[0].etc_display
      expect(etc).to eq('水1 水3')
    end

    it 'big' do
      big = subject[0].big
      expect(big).to eq('20140412 20140426 20140510 20140524 20140614 20140628 20140712 20140726 20140809 20140823 20140913 20140927 20141011 20141025 20141108 20141122 20141213 20141227 20150110 20150124 20150214 20150228 20150314 20150328 *1')
    end

    it 'unflammable' do
      unflammable = subject[0].unflammable
      expect(unflammable).to eq(["20140405", "20140419", "20140503", "20140517", "20140607", "20140621", "20140705", "20140719", "20140802", "20140816", "20140906", "20140920", "20141004", "20141018", "20141101", "20141115", "20141206", "20141220", "20140110", "20140117", "20140207", "20140221", "20140307", "20140321"])
    end

    it 'unflammable_display' do
      unflammable = subject[0].unflammable_display
      expect(unflammable).to eq('金1 金3')
    end
  end
end
