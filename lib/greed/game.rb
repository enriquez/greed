module Greed
  class Game
    def initialize players
      @players = players
      @dice_set = DiceSet.new
      @turns = 0
      @scores = Array.new
      @current_player = @players.first
      
      @players.each_with_index do |player, i|
        @scores << 0
        player.position = i
      end
    end
    
    def current_player_position
      pos = @players.index(@current_player) + 1
      "Player #{pos}"
    end
    
    def in_final_round?
      @scores.select { |score| score >= 3000 }.length > 0
    end
    
    def play_turn
      turn_score_contribution = 0
      turn_scores = Array.new
      dice_count = 5
      
      turn_continues = true
      while turn_continues
        score_and_dice_count = current_player_roll(dice_count)
        
        turn_scores << score_and_dice_count[:score]
        dice_count = score_and_dice_count[:dice_count]
        
        if turn_scores.include?(0)
          turn_continues = false
        elsif dice_count <= 0
          turn_continues = false
        end
        
        if turn_continues
          turn_continues = @current_player.keep_rolling?(stats, turn_scores)
        end
          
      end
      
      turn_score_contribution = turn_scores.inject(0) { |sum, i| sum += i }
      
      if (turn_score_contribution < 300 and stats[:round] == 1) or turn_scores.include?(0)
        turn_score_contribution = 0
      end
      
      @scores[@current_player.position] += turn_score_contribution
      @current_player = next_player
      @turns += 1
      
      turn_score_contribution
    end
    
    def play_round
      @players.each do
        play_turn
      end
    end
    
    def stats
      {
        :round => ((@turns / @players.length) + 1),
        :scores => @scores
      }
    end
    
    def self.score(dice)
      score = 0
      
      occurrences = count_die_occurances(dice)

      occurrences.each do |occurrence|
        score_contribution = 0
        die = occurrence.first
        hits = occurrence.last
        multiplier = die

        hits_over_3 = hits % 3
        multiplier = 10 if die == 1

        if hits >= 3
          score_contribution += multiplier * 100
        end

        if hits_over_3 > 0 and (die == 1 or die == 5)
          score_contribution += hits_over_3 * multiplier * 10
        end

        score += score_contribution
      end

      score
    end
    
    def self.non_scoring_dice_count(dice)
      non_scoring_dice_count = dice.length
      
      occurrences = count_die_occurances(dice)
      
      occurrences.each do |occurrence|
        scoring_dice_count = 0
        die = occurrence.first
        hits = occurrence.last
        hits_over_3 = hits % 3
        
        if hits >= 3
          scoring_dice_count += 3
        end
        
        if hits_over_3 > 0 and (die == 1 or die == 5)
          scoring_dice_count += hits_over_3
        end
        
        non_scoring_dice_count -= scoring_dice_count
      end
      
      non_scoring_dice_count
    end
    
    protected
    def self.count_die_occurances(dice)
      occurrences = {
        1 => 0,
        2 => 0,
        3 => 0,
        4 => 0,
        5 => 0,
        6 => 0
      }

      dice.each do |die|
        occurrences[die] += 1
      end
      
      occurrences
    end
    
    def current_player_roll(dice_count)
      roll_result = @current_player.roll(@dice_set, dice_count)
      
      score = Game.score(roll_result)
      dice_count = Game.non_scoring_dice_count(roll_result)
      
      UI.puts "Rolled a #{roll_result.join(",")} for a score of #{score}. #{dice_count} die left."
      { :score => score, :dice_count => dice_count }
    end
    
    def next_player
      @players[(@current_player.position + 1) % @players.length]
    end
  end
end