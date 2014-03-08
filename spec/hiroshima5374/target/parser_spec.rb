require 'spec_helper'

include Hiroshima5374

describe Target::Parser do
  describe '#targets' do
    subject { Target::Parser.new(target_sample_html).targets }
    it 'type' do
      type = subject.first[0]
      expect(type).to eq('不燃ゴミ')
    end

    it 'name' do
      name = subject.first[1]
      expect(name).to eq('アイスノン（保冷まくら）')
    end

    it 'notice' do
      notice = subject.first[2]
      expect(notice).to eq('丈夫なビニール袋に入れて出す。')
    end

    it 'furigana' do
      furigana = subject.first[3]
      expect(furigana).to eq('あ')
    end
  end
end
