# -*- coding: utf-8 -*-
require 'csv'
require 'fileutils'
require 'hiroshima5374/area_days/parser'

module Hiroshima5374::AreaDays
  HTML_FILES = [
    ["中区","http://www.city.hiroshima.lg.jp/www/contents/1456144057695/index.html"], # 中区1
    ["中区","http://www.city.hiroshima.lg.jp/www/contents/1456144459889/index.html"], # 中区2
    ["東区","http://www.city.hiroshima.lg.jp/www/contents/1456361729117/index.html"], # 東区1
    ["東区","http://www.city.hiroshima.lg.jp/www/contents/1456145335329/index.html"], # 東区2
    ["東区","http://www.city.hiroshima.lg.jp/www/contents/1456145516193/index.html"], # 旧安芸町
    ["南区","http://www.city.hiroshima.lg.jp/www/contents/1456220835482/index.html"], # 南区1
    ["南区","http://www.city.hiroshima.lg.jp/www/contents/1456221469862/index.html"], # 南区2
    ["西区","http://www.city.hiroshima.lg.jp/www/contents/1456551088481/index.html"], # 西区1
    ["西区","http://www.city.hiroshima.lg.jp/www/contents/1456222306031/index.html"], # 西区2
    ["安佐南区","http://www.city.hiroshima.lg.jp/www/contents/1456222765714/index.html"], # 安佐南区1
    ["安佐南区","http://www.city.hiroshima.lg.jp/www/contents/1456223516473/index.html"], # 安佐南区2
    ["安佐北区","http://www.city.hiroshima.lg.jp/www/contents/1456223986267/index.html"], # 安佐北区1
    ["安佐北区","http://www.city.hiroshima.lg.jp/www/contents/1456224409583/index.html"], # 安佐北区2
    ["安芸区","http://www.city.hiroshima.lg.jp/www/contents/1456224852543/index.html"], # 安芸区1
    ["安芸区","http://www.city.hiroshima.lg.jp/www/contents/1456225207410/index.html"], # 安芸区2
    ["佐伯区","http://www.city.hiroshima.lg.jp/www/contents/1456225546686/index.html"], # 佐伯区1
    ["佐伯区","http://www.city.hiroshima.lg.jp/www/contents/1456225859021/index.html"], # 佐伯区2
    ["佐伯区","http://www.city.hiroshima.lg.jp/www/contents/1456226370823/index.html"], # 佐伯区3
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
