require 'nokogiri'

module Hiroshima5374::Target
  class Parser
    def initialize(file)
      @file = file
      @furigana_count = 0
      @name_count = 0
      @type_count = 0
      @way_count = 0
      @notice_count = 0
    end

    def targets
      @targets ||= parse.to_a
    end

    def each(&block)
      targets.each(&block)
    end

    def parse
      text = open(@file).read
      doc = Nokogiri::HTML(text)
      trs = doc.css('table')[3].css('tr')
      trs.select { |tr|
        not ignore_tr? tr
      }.map { |tr|
        tds = tr.css('td')
        furigana = furigana(tds)
        name = name(tds)
        type = type(tds)
        notice = notice(type, tds)
        [
         type,
         name,
         notice,
         furigana
        ]
      }
    end

    def furigana(tds)
      if @furigana_count == 0
        td = tds.shift
        @furigana_count = td.attributes["rowspan"].value.to_i
        @furigana = td.text.strip
      end
      @furigana_count -= 1
      @furigana
    end

    def name(tds)
      td = tds.shift
      if td.attributes["colspan"]
        return td.text.tr("\r\n ",'')
      end

      if @name_count == 0
        rowspan = td.attributes["rowspan"]
        @name_count = 1
        @name_count = rowspan.value.to_i if rowspan
        @main_name = td.text.tr("\r\n ",'')
        td = tds.shift
      end
      @name_count -= 1
      [@main_name, td.text.strip].join(' ')
    end

    def type(tds)
      if @type_count == 0
        td = tds.shift
        rowspan = td.attributes["rowspan"]
        @type_count = 1
        @type_count = rowspan.value.to_i if rowspan
        @type_name = td.text.tr("\r\n ",'').gsub('ごみ','ゴミ')
      end
      @type_count -= 1
      @type_name
    end

    def notice(type, tds)
      if @way_count == 0
        td = tds.shift
        rowspan = td.attributes["rowspan"]
        @way_count = 1
        @way_count = rowspan.value.to_i if rowspan
        @way = td.text.tr("\r\n ",'')
      end
      @way_count -= 1

      if @notice_count == 0
        td = tds.shift
        rowspan = td.attributes["rowspan"]
        @notice_count = rowspan.value.to_i if rowspan
        @notice = td.text.tr("\r\n ",'')
        @notice = '' if @notice.size == 1
      end
      @notice_count -= 1

      notice = case type
               when '大型ゴミ'
                 @notice
               when '不燃ゴミ','資源ゴミ','その他プラ','有害ゴミ','リサイクルプラ','可燃ゴミ'
                 @way + @notice
               when '家電リサイクル法対象機器','―'
                 ''
               else
                 raise "予期しないタイプ #{type}"
               end
      notice unless notice.size == 0
    end

    def ignore_tr?(tr)
      tds = tr.children
      ignore_colors = ["#e7e7e7","#ffffff"]
      bgcolor = tds.first.attributes["bgcolor"].value
      return true if ignore_colors.include? bgcolor

      bgcolor = tds[2].attributes["bgcolor"].value
      return true if ignore_colors.include? bgcolor
    end
  end
end
