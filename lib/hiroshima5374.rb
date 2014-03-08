module Hiroshima5374
  require 'hiroshima5374/area_days'
end

require 'nokogiri'

# html_file = open("index.html").read

class Area
  
end

def parse(text)
  doc = Nokogiri::HTML(text)
  nodesets = doc.css('table')
  raise "予期しないHTMLです" unless nodesets.count == 3
  @first_table = nodesets[1]
  @second_table = nodessets[2]
  areas
end

def flammable
  @first_table.css("td")[0].text
  flammable.css("td")[0].text
end

def areas
  nums = @first_table.css("tr").count / 2 - 1
  numes.times
  require 'pry'; binding.pry
end

# parse(html_file)

