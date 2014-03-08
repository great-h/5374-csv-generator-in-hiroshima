require 'csv'
require 'fileutils'

module Hiroshima5374::Target
  HTML_FILES = [
    "http://www.city.hiroshima.lg.jp/www/contents/0000000000000/1277095003184/index.html",
    "http://www.city.hiroshima.lg.jp/www/contents/0000000000000/1277193991784/index.html",
    "http://www.city.hiroshima.lg.jp/www/contents/0000000000000/1277261742268/index.html",
    "http://www.city.hiroshima.lg.jp/www/contents/0000000000000/1277274582025/index.html",
    "http://www.city.hiroshima.lg.jp/www/contents/0000000000000/1277277472954/index.html",
    "http://www.city.hiroshima.lg.jp/www/contents/0000000000000/1277363424007/index.html",
    "http://www.city.hiroshima.lg.jp/www/contents/0000000000000/1277431455385/index.html",
    "http://www.city.hiroshima.lg.jp/www/contents/0000000000000/1277431508075/index.html",
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
          Parser.new(file).each do |target|
            csv << target.to_a
          end
        end
      end
    end

    private

      def header
        %w{type name notice furigana}
      end

      def dirname
        'data'
      end

      def filename
        File.join(dirname,"target.csv")
      end
  end
end
