require File.dirname(__FILE__) + '/../test_helper'

class TestConsole < Test::Unit::TestCase
  
  def setup
    @out = StringIO.new
    @in = StringIO.new
    @console = Console.new(@out, @in)
  end
  
  def test_ask_for_players_selects_two_players
    user_inputs_sequence %w[2 1 3]
    
    players = @console.ask_for_players
    
    expected_output = <<-OUTPUT
Select Player 1
[1] human
[2] robot
Select Player 2
[1] human
[2] robot
Select Player 3
[1] human
[2] robot
[3] done
    OUTPUT
    
    assert_equal expected_output, @out.string
    assert_equal [:robot, :human], players
  end
  
  def test_player_rolls
    roll_result = { :score => 150, :dice_remaining => 3, :dice_result => [1,2,3,4,5] }
    
    @console.player_rolls(player, roll_result)
    
    assert_equal "Player 1 rolled a [1, 2, 3, 4, 5] for a score of 150. 3 die remaining.\n", @out.string
  end
  
  def test_player_stops_rolling
    @console.player_stops_rolling(player)
    
    assert_equal "Player 1 decides to stop rolling\n", @out.string
  end
  
  def test_player_rolls_a_zero
    @console.player_rolls_a_zero(player)
    
    assert_equal "Player 1 rolled a zero!\n", @out.string
  end
  
  def test_player_used_all_the_dice
    @console.player_used_all_the_dice(player)
    
    assert_equal "Player 1 used all the dice!\n", @out.string
  end
  
  def test_player_starts_turn
    @console.player_starts_turn(player)
    
    assert_equal "\n=== Player 1's turn ===\n", @out.string
  end
  
  def test_player_ends_turn
    turn_score = 1000
    
    @console.player_ends_turn(player, turn_score)
    
    assert_equal "=== Player 1 ends turn and adds 1000 points ===\n", @out.string
  end
  
  def test_display_stats
    stats = { :scores => [100, 0, 2500], :in_the_game => [true, false, true], :players => %w[Jen Robo Mike] }
    
    @console.display_stats(stats)
    
    expected_output = <<-OUTPUT
|         | Player 1 | Player 2 | Player 3 |
|   Score | 100      | 0        | 2500     |
|In Game? | true     | false    | true     |
    OUTPUT
    assert_equal expected_output, @out.string
  end
  
  def user_inputs_sequence input_sequence
    sequence = sequence("user input sequence")
    input_sequence.each do |input|
      UI.expects(:gets).returns(input).in_sequence(sequence)
    end
  end
  
  def player
    stub(:position => 0)
  end
end