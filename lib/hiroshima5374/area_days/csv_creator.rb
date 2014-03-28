require 'csv'
require 'fileutils'
require 'hiroshima5374/area_days/parser'

module Hiroshima5374::AreaDays
  HTML_FILES = [
    ["中区","http://www.city.hiroshima.lg.jp/www/contents/0000000000000/1391305461871/index.html"], # 中区1
    ["中区","http://www.city.hiroshima.lg.jp/www/contents/0000000000000/1391309415197/index.html"], # 中区2
    ["東区","http://www.city.hiroshima.lg.jp/www/contents/0000000000000/1391405929743/index.html"], # 東区1
    ["東区","http://www.city.hiroshima.lg.jp/www/contents/0000000000000/1391407049672/index.html"], # 東区2
    ["東区","http://www.city.hiroshima.lg.jp/www/contents/0000000000000/1391407878202/index.html"], # 旧安芸町
    ["南区","http://www.city.hiroshima.lg.jp/www/contents/0000000000000/1391505635167/index.html"], # 南区1
    ["南区","http://www.city.hiroshima.lg.jp/www/contents/0000000000000/1391505696447/index.html"], # 南区2
    ["西区","http://www.city.hiroshima.lg.jp/www/contents/0000000000000/1391753077594/index.html"], # 西区1
    ["西区","http://www.city.hiroshima.lg.jp/www/contents/0000000000000/1391754756402/index.html"], # 西区2
    ["安佐南区","http://www.city.hiroshima.lg.jp/www/contents/0000000000000/1391642968138/index.html"], # 安佐南区1
    ["安佐南区","http://www.city.hiroshima.lg.jp/www/contents/0000000000000/1391643100202/index.html"], # 安佐南区2
    ["安佐北区","http://www.city.hiroshima.lg.jp/www/contents/0000000000000/1391643228357/index.html"], # 安佐北区1
    ["安佐北区","http://www.city.hiroshima.lg.jp/www/contents/0000000000000/1391643274282/index.html"], # 安佐北区2
    ["安芸区","http://www.city.hiroshima.lg.jp/www/contents/0000000000000/1391505741218/index.html"], # 安芸区1
    ["安芸区","http://www.city.hiroshima.lg.jp/www/contents/0000000000000/1391505770905/index.html"], # 安芸区2
    ["佐伯区","http://www.city.hiroshima.lg.jp/www/contents/0000000000000/1391746541022/index.html"], # 佐伯区1
    ["佐伯区","http://www.city.hiroshima.lg.jp/www/contents/0000000000000/1391746605494/index.html"], # 佐伯区2
    ["佐伯区","http://www.city.hiroshima.lg.jp/www/contents/0000000000000/1391746733925/index.html"], # 佐伯区3
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
