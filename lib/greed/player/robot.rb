module Greed
  module Player
    class Robot < Base
      
      def name
        "Robot"
      end
      
      def keep_rolling?(stats, turn_scores, dice_remaining)
        dice_remaining >= 3
      end
    end
  end
end