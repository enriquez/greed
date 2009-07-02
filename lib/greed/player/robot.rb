module Greed
  module Player
    class Robot < Base
      
      def name
        "Robot"
      end
      
      def keep_rolling?(stats, turn_scores)
        @position # => 0.  This is your index to be used in the arrays inside stats.
        stats # => { :scores => [100, 0, 300], :in_the_game => [true, false, true] }
        turn_scores # => [100, 150].  This array contains the scores for your current turn.
        false
      end
    end
  end
end