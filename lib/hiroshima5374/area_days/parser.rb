module Hiroshima5374::AreaDays
  class Parser
    def initialize(file)
      @file = file
    end

    def areas
      @areas ||= []
    end

    def each(&blogk)
      areas.each(&:block)
    end
  end
end
