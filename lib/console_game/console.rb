module ConsoleGame
  class Console
    include Greed
    
    def initialize(out_stream, in_stream)
      @ui = UI
      @ui.out_stream = out_stream
      @ui.in_stream = in_stream
    end
    
    def start
      players = Array.new
      
      @ui.puts "Welcome to Greed"
      
      selected_players = ask_for_players
      selected_players.each do |selected_player|
        case selected_player
        when :human
          players << ConsoleGame::Player::Human.new
        when :robot
          players << Greed::Player::Robot.new
        end
      end
      
      game = Game.new(players, self)
      
      while !game.in_final_round?
        game.play_turn
        display_stats game.stats
      end
      
      @ui.puts ""
      @ui.puts "================== FINAL ROUND =================="
      
      (players.length - 1).times { game.play_turn }
      
      @ui.puts ""
      @ui.puts "FINAL STATS"
      display_stats game.stats
    end
    
    def ask_for_players
      players = Array.new
      selecting_players = true
      player_count = 1
      
      while selecting_players
        options = [:human, :robot]
        options << :done if player_count >= 3
        
        player = @ui.choose("Select Player #{player_count}", options)
        
        if player == :done
          selecting_players = false
        else
          players << player
          player_count += 1
        end
      end
      
      players
    end
    
    def player_rolls player, roll_result
      player_position = player.position + 1
      dice_result = roll_result[:dice_result].join(", ")
      score = roll_result[:score]
      dice_remaining = roll_result[:dice_remaining]
      
      @ui.puts "Player #{player_position} rolled a [#{dice_result}] for a score of #{score}. #{dice_remaining} die remaining."
    end
    
    def player_starts_turn(player)
      player_position = player.position + 1
      
      @ui.puts ""
      @ui.puts "=== Player #{player_position}'s turn ==="
    end
    
    def player_stops_rolling(player)
      player_position = player.position + 1
            
      @ui.puts "Player #{player_position} decides to stop rolling"
    end
    
    def player_rolls_a_zero(player)
      player_position = player.position + 1
            
      @ui.puts "Player #{player_position} rolled a zero!"
    end
    
    def player_used_all_the_dice(player)
      player_position = player.position + 1
            
      @ui.puts "Player #{player_position} used all the dice!"
    end
    
    def player_ends_turn(player, turn_score)
      player_position = player.position + 1
      
      @ui.puts "=== Player #{player_position} ends turn and adds #{turn_score} points ==="
    end
    
    def display_stats stats
      players_row = "|         |"
      scores_row  = "|   Score |"
      in_game_row = "|In Game? |"
      
      stats[:players].each_with_index do |player, i|
        players_row << " Player #{i + 1} |"
      end
      
      stats[:scores].each do |score|
        scores_row << " #{score}".ljust(10) << "|"
      end
      
      stats[:in_the_game].each do |in_the_game|
        in_game_row << " #{in_the_game}".ljust(10) << "|"
      end
      
      @ui.puts players_row
      @ui.puts scores_row
      @ui.puts in_game_row
    end
  end
end