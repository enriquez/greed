module Greed
  class DiceSet
    attr_reader :values
    def roll(n)
      @values = (1..n).map { rand(6) + 1 }
    end
  end
end