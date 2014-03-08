require 'csv'
require 'fileutils'
require 'hiroshima5374/area_days/parser'

module Hiroshima5374::AreaDays
  HTML_FILES = [
    "http://www.city.hiroshima.lg.jp/www/contents/0000000000000/1359632161939/index.html" # 可部 安佐
  ]

  class CSVCreator
    class << self
      def create
        new(HTML_FILES).create
      end
    end

    def initialize(files)
      @html_files = files
    end

    def create
      FileUtils.mkdir_p dirname
      CSV.open(filename,'wb') do |csv|
        csv << header
        @html_files.each do |file|
          Parser.new(file).each do |area|
            csv << area.to_a
          end
        end
      end
    end

    private

      def header
        %W{地名 センター 可燃ゴミ ペットボトル リサイクルプラ 資源ゴミ 有害ゴミ その他プラ 大型ゴミ 不燃ゴミ}
      end

      def dirname
        'data'
      end

      def filename
        File.join(dirname,"area_days.csv")
      end
  end
end
