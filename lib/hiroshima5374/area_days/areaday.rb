module Hiroshima5374::AreaDays
  class Areaday
    attr_accessor :area, :flammable, :petbottle, :resource, :resource_display
    attr_accessor :etc, :etc_display, :big, :unflammable, :unflammable_display

    def to_a
      [
       area,
       nil, # center
       flammable,
       petbottle,
       petbottle,
       resource.join(" "),
       resource.join(" "),
       etc.join(" "),
       big,
       unflammable.join(" "),
      ]
    end
  end
end
