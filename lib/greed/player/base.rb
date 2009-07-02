module Greed
  module Player
    class Base
      attr_accessor :position
      
      def name
        "Ace of Base"
      end
      
      def position
        @position || 0
      end
      
      def roll(dice_set, die_count)
        dice_set.roll(die_count)
      end
      
      def keep_rolling?(stats, turn_scores, dice_remaining)
        # implemented by subclass
      end
    end
  end
end