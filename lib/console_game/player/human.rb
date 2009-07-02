module ConsoleGame
  module Player
    class Human < Greed::Player::Base
      
      def initialize
        @ui = UI
      end
      
      def name
        "Human"
      end
      
      def keep_rolling?(stats, turn_scores, dice_remaining)
        @ui.ask("Player #{@position + 1}: Keep Rolling?")
      end
    end
  end
end