require 'nokogiri'
require 'open-uri'

module Hiroshima5374::AreaDays
  class Parser
    WEEK_DAYS = '月火水木金土日'.freeze

    def initialize(file)
      @file = file
      @flammable_count = 0
      @petbottle_count = 0
    end

    def areas
      @areas ||= parse.to_a
    end

    def parse
      text = open(@file).read
      doc = Nokogiri::HTML(text)
      nodesets = doc.css('table')
      raise "予期しないHTMLです" unless nodesets.count == 3

      parse_trs(nodesets).map do |first,second,third,fourth|
        flammable = flammable(first)
        petbottle = petbottle(first)
        resource = resource(first,second)
        area = area(first)
        etc = etc(first,second)
        big = big(third,fourth)
        unflammable = unflammable(third,fourth)
        [
         area,
         nil, # center
         flammable,
         petbottle,
         petbottle,
         resource,
         resource,
         etc,
         big,
         unflammable
        ]
      end
    end

    def parse_trs(nodesets)
      Enumerator.new do |y|
        first_trs = nodesets[1].css("tr")
        second_trs = nodesets[2].css("tr")

        next_line = proc do
          [first_trs.shift, first_trs.shift, second_trs.shift, second_trs.shift]
        end
        # skip headeer
        next_line.call

        loop do
          line = next_line.call
          break if line[0].nil?
          y << line.map { |tr| tr.css('td') }
        end
      end
    end


    def each(&block)
      areas.each(&block)
    end

    private

      def flammable(tds)
        if @flammable_count == 0
          flammable = tds[0]
          @flammable_count = flammable.attributes["rowspan"].value.to_i / 2
          @flammable = flammable.text.gsub(/曜日/,'')
            .gsub(/[^#{WEEK_DAYS}]/,'')
            .each_char
            .to_a
            .join(' ')
          tds.shift
        end
        @flammable_count -= 1
        @flammable
      end

      def petbottle(tds)
        if @petbottle_count == 0
          petbottle = tds[0]
          @petbottle_count = petbottle.attributes["rowspan"].value.to_i / 2
          @petbottle = petbottle.text.gsub(/曜日/,'')
            .gsub(/[^#{WEEK_DAYS}]/,'')
          tds.shift
        end
        @petbottle_count -= 1
        @petbottle
      end

      def resource(first,second)
        '20150101'
      end

      def area(tds)
        tds[14].children.map do |element|
          case element
          when Nokogiri::XML::Text
            element.text.strip
          when Nokogiri::XML::Element
            ' '
          end
        end.join
      end

      def etc(first, second)
        '20150101'
      end

      def big(first, second)
        '20150101'
      end

      def etc(first, second)
        '20150101'
      end

      def unflammable(first, second)
        '20150101'
      end
  end
end
