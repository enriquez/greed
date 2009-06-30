module Greed
  module Player
    class Human < Base
      
      def initialize
        @ui = UI
      end
      
      def name
        "Player #{@position + 1}"
      end
      
      def keep_rolling?(stats, turn_scores)
        @ui.ask("Keep Rolling?")
      end
    end
  end
end