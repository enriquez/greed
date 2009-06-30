module Greed
  module Player
    class Robot < Base
      
      def name
        "Robot"
      end
      
      def keep_rolling?(stats, turn_scores)
        false
      end
    end
  end
end