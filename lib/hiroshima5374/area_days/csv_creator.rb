require 'csv'
require 'fileutils'
require 'hiroshima5374/area_days/parser'

module Hiroshima5374::AreaDays
  HTML_FILES = [
    ["中区","http://www.city.hiroshima.lg.jp/www/contents/0000000000000/1359632161939/index.html"], # 中区1
    ["中区","http://www.city.hiroshima.lg.jp/www/contents/0000000000000/1359372094205/index.html"], # 中区2
    ["東区","http://www.city.hiroshima.lg.jp/www/contents/0000000000000/1359604219035/index.html"], # 東区1
    ["東区","http://www.city.hiroshima.lg.jp/www/contents/0000000000000/1359604380371/index.html"], # 東区2
    ["東区","http://www.city.hiroshima.lg.jp/www/contents/0000000000000/1359604516583/index.html"], # 旧安芸町
    ["南区","http://www.city.hiroshima.lg.jp/www/contents/0000000000000/1359604623155/index.html"], # 南区1
    ["南区","http://www.city.hiroshima.lg.jp/www/contents/0000000000000/1359604737620/index.html"], # 南区2
    ["西区","http://www.city.hiroshima.lg.jp/www/contents/0000000000000/1359630981158/index.html"], # 西区1
    ["西区","http://www.city.hiroshima.lg.jp/www/contents/0000000000000/1359631356652/index.html"], # 西区2
    ["安佐南区","http://www.city.hiroshima.lg.jp/www/contents/0000000000000/1359631555774/index.html"], # 安佐南区1
    ["安佐南区","http://www.city.hiroshima.lg.jp/www/contents/0000000000000/1359631985205/index.html"], # 安佐南区2
    ["安佐北区","http://www.city.hiroshima.lg.jp/www/contents/0000000000000/1359632161939/index.html"], # 安佐北区1
    ["安佐北区","http://www.city.hiroshima.lg.jp/www/contents/0000000000000/1359632302679/index.html"], # 安佐北区2
    ["安芸区","http://www.city.hiroshima.lg.jp/www/contents/0000000000000/1359632454021/index.html"], # 安芸区1
    ["安芸区","http://www.city.hiroshima.lg.jp/www/contents/0000000000000/1359632597887/index.html"], # 安芸区2
    ["佐伯区","http://www.city.hiroshima.lg.jp/www/contents/0000000000000/1359632754298/index.html"], # 佐伯区1
    ["佐伯区","http://www.city.hiroshima.lg.jp/www/contents/0000000000000/1359632914854/index.html"], # 佐伯区2
    ["佐伯区","http://www.city.hiroshima.lg.jp/www/contents/0000000000000/1359633203690/index.html"], # 佐伯区3
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
        @html_files.each do |ward, file|
          Parser.new(ward, file).each do |area|
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
