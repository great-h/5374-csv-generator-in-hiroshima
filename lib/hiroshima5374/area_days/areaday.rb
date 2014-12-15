module Hiroshima5374::AreaDays
  class Areaday
    attr_accessor :area, :flammable, :petbottle, :resource, :resource_display
    attr_accessor :etc, :etc_display, :big, :unflammable, :unflammable_display

    def to_a
      r = resource.join(" ") + " " + resource_display
      e = etc.join(" ") + " " + etc_display
      u = unflammable.join(" ") + " " + unflammable_display
      [
       area,
       nil, # center
       flammable,
       petbottle,
       petbottle,
       r,
       r,
       e,
       big,
       u,
      ]
    end
  end
end
