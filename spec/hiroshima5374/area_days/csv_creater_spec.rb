require 'hiroshima5374'

include Hiroshima5374::AreaDays

describe CSVCreator do
  spec_root = File.join(File.dirname(__FILE__), "..", "..")
  sample_html = File.join(spec_root, "data", "index.html")
  csv_file = File.join(spec_root, "data", "area_days.csv")

  before :each do
    FileUtils.cd spec_root
    if (File.exist?(csv_file))
      FileUtils.rm csv_file
    end
  end

  describe '#create' do
    subject { CSVCreator.new([sample_html]).create }
    it 'area_days.csv が作成される' do
      subject
      expect(File.exist?(csv_file)).to be_true
    end
  end
end
