require 'nokogiri'
require 'open-uri'

module Hiroshima5374::AreaDays
  class Parser
    WEEK_DAYS = '月火水木金土日'.freeze

    def initialize(ward, file)
      @ward = ward
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
        two_week_base(first,second)
      end

      def area(tds)
        tds.shift.children.map do |element|
          case element
          when Nokogiri::XML::Text
            element.text.strip
          when Nokogiri::XML::Element
            ' '
          end
        end.unshift("#{@ward} ").join
      end

      def etc(first, second)
        two_week_base(first, second)
      end

      def big(first, second)
        time = Time.now
        month = time.month
        year = time.year
        if month < 4
          year -= 1
        end
        months = (4..12).to_a + (1..3).to_a
        months.map do |n|
          year += 1 if n == 1
          date = proc do |day|
            day = day.text.gsub(/[^[:digit:]]/,'')
            Time.new(year,n,day).strftime("%Y%m%d")
          end
          [date.call(first.shift),date.call(second.shift)]
        end.flatten.push('*1').join(' ')
      end

      def unflammable(first, second)
        first.shift # 収集地区を読み飛ばし
        two_week_base(first,second)
      end

      def two_week_base(first, second)
        n_week = first.shift.text.gsub(/[^[:digit:]]/,'')
        week_day = first.shift.text.strip

        12.times do
          first.shift
          second.shift
        end

        n_week.each_char.map do |n|
          "#{week_day}#{n}"
        end.join(' ')
      end
  end
end
