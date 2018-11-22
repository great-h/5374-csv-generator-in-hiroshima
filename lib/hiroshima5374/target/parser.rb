# coding: utf-8
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

        ret = [
         type,
         name,
         notice,
         furigana
        ]
        p ret if $DEBUG
        ret
      }
    end

    def furigana(tds)
      if @furigana_count == 0
        td = tds.shift
        @furigana_count = 1
        rowspan = td.attributes["rowspan"]
        @furigana_count = rowspan.value.to_i if rowspan
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
      [@main_name, td.text.tr("\r\n ",'')].join(' ')
    end

    def type(tds)
      if @type_count == 0
        td = tds.shift
        rowspan = td.attributes["rowspan"]
        @type_count = 1
        @type_count = rowspan.value.to_i if rowspan
        @type_name = td.text.tr("\r\n ",'').gsub('ゴミ', 'ごみ')
      end
      @type_count -= 1
      @type_name
    end

    def notice(type, tds)
      if @way_count == 0
        td = tds.shift
        @way_count = 1
        @way = ''
        if td
          rowspan = td.attributes["rowspan"]
          @way_count = rowspan.value.to_i if rowspan
          @way = td.text.tr("\r\n ",'')
        end
      end
      @way_count -= 1

      if @notice_count <= 0
        td = tds.shift
        if td
          rowspan = td.attributes["rowspan"]
          @notice_count = rowspan.value.to_i if rowspan
          @notice = td.text.tr("\r\n ",'')
          @notice = '' if @notice.size == 1
        end
      end
      @notice_count -= 1

      notice = case type
               when '大型ごみ'
                 @notice
               when '不燃ごみ','資源ごみ','その他プラ','有害ごみ','リサイクルプラ','可燃ごみ','ペットボトル'
                 @way + @notice
               when '家電リサイクル法対象機器','―','---',' ',"品目「将棋盤・碁盤」に掲載しています。  ",' ---','品目「かばん」に掲載しています。'
                 ''
               else
                 raise "#{@file} に予期しないタイプ #{type} がありました。"
               end
      notice unless notice.size == 0
    end

    def ignore_tr?(tr)
      tds = tr.css('td')
      ignore_colors = ["#e7e7e7","#ffffff"]

      td = tds.first
      colspan = td.attributes["colspan"]
      if colspan
        return true if colspan.value.to_i > 2
      end

      bgcolor = td.attributes["bgcolor"]
      return false if bgcolor.nil?
      return true if ignore_colors.include? bgcolor.value

      tds2 = tds[2]
      return false if tds2.nil?

      attributes = tds2.attributes
      return false if attributes.empty?

      bgcolor = attributes["bgcolor"]
      return false if bgcolor.nil?
      ignore_colors.include? bgcolor.value
    end
  end
end
