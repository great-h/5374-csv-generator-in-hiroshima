require 'spec_helper'

include Hiroshima5374

describe Target::CSVCreator do

  csv_file = File.join(spec_root, "data", "target.csv")

  before :each do
    FileUtils.cd spec_root
    if (File.exist?(csv_file))
      FileUtils.rm csv_file
    end
  end

  after :each do
    FileUtils.cd File.join(spec_root, '..')
  end

  describe '#create' do
    subject { Target::CSVCreator.new([target_sample_html]).create }
    it 'target.csv が作成される' do
      subject
      expect(File.exist?(csv_file)).to be_true
    end
  end
end
