require 'spec_helper'

include Hiroshima5374::AreaDays

describe CSVCreator do

  csv_file = File.join(spec_root, "data", "area_days.csv")

  before :each do
    FileUtils.cd spec_root
    if (File.exist?(csv_file))
      FileUtils.rm csv_file
    end
  end

  describe '#create' do
    subject { CSVCreator.new([['区',sample_html]]).create }
    it 'area_days.csv が作成される' do
      subject
      expect(File.exist?(csv_file)).to be_true
    end
  end
end
