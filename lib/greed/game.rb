module Greed
  class Game
    attr_reader :current_player
    
    FINAL_ROUND_SCORE = 3000
    IN_THE_GAME_SCORE = 300
    
    def initialize players, spectator
      @players = players
      @spectator = spectator
      @dice_set = DiceSet.new
      @scores = Array.new
      @in_the_game = Array.new
      @player_names = Array.new
      @current_player = @players.first
      
      @players.each_with_index do |player, i|
        @scores << 0
        @in_the_game << false
        @player_names << player.name
        player.position = i
      end
    end
    
    def in_final_round?
      @scores.select { |score| score >= FINAL_ROUND_SCORE }.length > 0
    end
    
    def play_turn
      @spectator.player_starts_turn(@current_player)
      
      turn_score_contribution = 0
      turn_scores = Array.new
      dice_count = 5
      
      turn_continues = true
      while turn_continues
        result = current_player_roll(dice_count)
        
        turn_scores << result[:score]
        dice_count = result[:dice_remaining]
        
        if turn_scores.include?(0)
          turn_continues = false
          @spectator.player_rolls_a_zero(@current_player)
        end
        if dice_count <= 0
          turn_continues = false
          @spectator.player_used_all_the_dice(@current_player)
        end
        
        if turn_continues
          turn_continues = @current_player.keep_rolling?(stats, turn_scores)
          unless turn_continues
            @spectator.player_stops_rolling(@current_player)
          end
        end
          
      end
      
      turn_score_contribution = turn_scores.inject(0) { |sum, i| sum += i }
      
      if (turn_score_contribution < IN_THE_GAME_SCORE and !@in_the_game[@current_player.position]) or turn_scores.include?(0)
        turn_score_contribution = 0
      else
        @in_the_game[@current_player.position] = true
      end
      
      @scores[@current_player.position] += turn_score_contribution
      @current_player = next_player
      
      @spectator.player_ends_turn(@current_player, turn_score_contribution)
      
      turn_score_contribution
    end
    
    def stats
      {
        :scores => @scores,
        :in_the_game => @in_the_game,
        :players => @player_names
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
      dice_remaining = Game.non_scoring_dice_count(roll_result)
      
      output = { :score => score, :dice_remaining => dice_remaining, :dice_result => roll_result }
      
      @spectator.player_rolls(@current_player, output)
      
      output
    end
    
    def next_player
      @players[(@current_player.position + 1) % @players.length]
    end
  end
end