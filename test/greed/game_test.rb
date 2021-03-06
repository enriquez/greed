require File.dirname(__FILE__) + '/../test_helper'

class TestGame < Test::Unit::TestCase
  
  def setup
    @player_1 = player_stub(:name => "Mike", :position => 0)
    @player_2 = player_stub(:name => "Jen", :position => 1)
    @player_3 = player_stub(:name => "Mr. Robo", :position => 2)
    
    @player_1.expects(:position=).with(0)
    @player_2.expects(:position=).with(1)
    @player_3.expects(:position=).with(2)
    
    @spectator = stub_everything
    
    @game = Game.new([@player_1, @player_2, @player_3], @spectator)
  end
  
  def test_sanity_check_for_player_stub
    assert_equal "Player Name", player_stub.name
    assert_equal "Mike", @player_1.name
    assert_equal "Jen", @player_2.name
    assert_equal "Mr. Robo", @player_3.name
  end
  
  def test_initial_stats
    expected = { :scores => [0,0,0], :in_the_game => [false,false,false], :players => ["Mike", "Jen", "Mr. Robo"] }
    assert_equal expected, @game.stats
  end
  
  def test_current_player
    assert_equal @player_1, @game.current_player
  end
  
  def test_current_player_not_in_game
    assert !@game.stats[:in_the_game][0]
  end
  
  def test_game_is_not_in_final_round
    assert !@game.in_final_round?
  end
  
  def test_play_turn_rolls_once_then_stops
    player_rolls_once(@player_1, [1,1,1,2,3])
    
    turn_score_result = @game.play_turn
    
    assert_equal 1000, turn_score_result
    assert_equal 1000, @game.stats[:scores][0]
  end
  
  def test_play_turn_rolls_twice_then_stops
    player_rolls_turn_sequence @player_1, [[1,1,1,2,3],[2,5]]
    turn_score_result = @game.play_turn
    
    assert_equal 1050, turn_score_result
    assert_equal 1050, @game.stats[:scores][0]
  end
  
  def test_play_turn_rolls_twice_then_runs_out_of_dice
    player_rolls_turn_sequence @player_1, [[1,1,1,2,3],[5,5]]
    turn_score_result = @game.play_turn
    
    assert_equal 1100, turn_score_result
    assert_equal 1100, @game.stats[:scores][0]
  end
  
  def test_play_turn_rolls_twice_then_scores_a_zero
    player_rolls_turn_sequence @player_1, [[1,1,1,2,3],[2,2]]
    turn_score_result = @game.play_turn
    
    assert_equal 0, turn_score_result
    assert_equal 0, @game.stats[:scores][0]
  end
  
  def test_turn_score_does_not_count_if_not_in_game
    player_rolls_once(@player_1, [1,2,3,4,5])
    @game.play_turn
    
    assert_equal 0, @game.stats[:scores][0]
    
    player_rolls_once(@player_2, [1,1,1,2,3])
    @game.play_turn
    
    player_rolls_once(@player_3, [1,1,1,2,3])
    @game.play_turn
    
    assert !@game.stats[:in_the_game][0]
    
    player_rolls_once(@player_1, [1,5,4,2,3])
    @game.play_turn
    
    assert_equal 0, @game.stats[:scores][0]
  end
  
  def test_turn_score_counts_if_in_game
    player_rolls_once(@player_1, [3,3,3,4,2])
    @game.play_turn
    
    assert_equal 300, @game.stats[:scores][0]
    
    player_rolls_once(@player_2, [1,1,1,2,3])
    @game.play_turn
    
    player_rolls_once(@player_3, [1,1,1,2,3])
    @game.play_turn
    
    assert @game.stats[:in_the_game][0]
    
    player_rolls_once(@player_1, [1,5,4,2,3])
    @game.play_turn
    
    assert_equal 450, @game.stats[:scores][0]
  end
  
  def test_should_be_in_final_round_if_a_player_reaches_3000
    player_rolls_once(@player_1, [2,2,3,4,6])
    @game.play_turn
    assert !@game.in_final_round?
    
    player_rolls_once(@player_2, [1,1,1,4,6])
    @game.play_turn
    assert !@game.in_final_round?
    
    player_rolls_once(@player_3, [2,2,3,4,6])
    @game.play_turn
    assert !@game.in_final_round?
    
    player_rolls_once(@player_1, [2,2,3,4,6])
    @game.play_turn
    assert !@game.in_final_round?
    
    player_rolls_once(@player_2, [1,1,1,4,6])
    @game.play_turn
    assert !@game.in_final_round?
    
    player_rolls_once(@player_3, [2,2,3,4,6])
    @game.play_turn
    assert !@game.in_final_round?
    
    player_rolls_once(@player_1, [2,2,3,4,6])
    @game.play_turn
    assert !@game.in_final_round?
    
    player_rolls_once(@player_2, [1,1,1,4,6])
    @game.play_turn    
    assert @game.in_final_round?
    assert_equal 3000, @game.stats[:scores][1]
  end
  
  def test_player_rolls_once_test_helper
    @player = player_stub
    player_rolls_once @player, [1,2,3,4,5]
    
    assert_equal [1,2,3,4,5], @player.roll
    assert !@player.keep_rolling?
  end
  
  def test_player_rolls_turn_sequence_test_helper
    @player = player_stub
    player_rolls_turn_sequence @player, [[1,2,3,4,5],[1,3,4],[2,5]]
    
    assert_equal [1,2,3,4,5], @player.roll
    assert @player.keep_rolling?
    assert_equal [1,3,4], @player.roll
    assert @player.keep_rolling?
    assert_equal [2,5], @player.roll
    assert !@player.keep_rolling?
  end
  
  def player_rolls_once player, roll_result
    player.expects(:roll).with(any_parameters).returns(roll_result)
    player.expects(:keep_rolling?).with(any_parameters).returns(false).at_most_once
  end
  
  def player_rolls_turn_sequence player, roll_results
    roll_sequence = sequence("roll sequence")
    
    # first roll
    player.expects(:roll).
      with(any_parameters).
      returns(roll_results.slice!(0)).
      in_sequence(roll_sequence)
    player.expects(:keep_rolling?).
      with(any_parameters).
      returns(true).
      in_sequence(roll_sequence)
          
    last_roll_result = roll_results.last
      
    # iterate through each subsequent roll
    roll_results.each do |roll_result|
      keep_rolling = last_roll_result != roll_result
      
      player.expects(:roll).
        with(any_parameters).
        returns(roll_result).
        in_sequence(roll_sequence)
      player.expects(:keep_rolling?).
        with(any_parameters).
        returns(keep_rolling).
        at_most_once.
        in_sequence(roll_sequence)
    end
  end
  
  def player_stub(method_results = {})
    default_method_results = {
      :name => "Player Name"
    }
    
    stub(default_method_results.merge(method_results))
  end
end

class TestScoring < Test::Unit::TestCase
  def test_score_of_an_empty_list_is_zero
    assert_equal 0, Game.score([])
  end

  def test_score_of_a_single_roll_of_5_is_50
    assert_equal 50, Game.score([5])
  end

  def test_score_of_a_single_roll_of_1_is_100
    assert_equal 100, Game.score([1])
  end

  def test_score_of_mulitple_1s_and_5s_is_the_sum
    assert_equal 300, Game.score([1,5,5,1])
  end

  def test_score_of_single_2s_3s_4s_and_6s_are_zero
    assert_equal 0, Game.score([2,3,4,6])
  end

  def test_score_of_a_triple_1_is_1000
    assert_equal 1000, Game.score([1,1,1])
  end

  def test_score_of_other_triples_is_100x
    assert_equal 200, Game.score([2,2,2])
    assert_equal 300, Game.score([3,3,3])
    assert_equal 400, Game.score([4,4,4])
    assert_equal 500, Game.score([5,5,5])
    assert_equal 600, Game.score([6,6,6])
  end

  def test_score_of_mixed_is_sum
    assert_equal 250, Game.score([2,5,2,2,3])
    assert_equal 550, Game.score([5,5,5,5])
  end
  
  def test_non_scoring_dice_of_empty_list_is_zero
    assert_equal 0, Game.non_scoring_dice_count([])
  end
  
  def test_non_scoring_dice_count_of_a_one_is_zero
    assert_equal 0, Game.non_scoring_dice_count([1])
  end
  
  def test_non_scoring_dice_count_of_a_five_is_zero
    assert_equal 0, Game.non_scoring_dice_count([5])
  end
  
  def test_non_scoring_dice_count_of_mixed_ones_and_fives_is_zero
    assert_equal 0, Game.non_scoring_dice_count([1,1,1,1,1])
    assert_equal 0, Game.non_scoring_dice_count([5,5,5,5,5])
    assert_equal 0, Game.non_scoring_dice_count([1,1,5,5])
  end
  
  def test_non_scoring_dice_count_of_2s_3s_4s_and_6s_are_non_scoring
    assert_equal 4, Game.non_scoring_dice_count([2,3,4,6])
  end
  
  def test_non_scoring_dice_count_of_triples_is_zero
    assert_equal 0, Game.non_scoring_dice_count([1,1,1])
    assert_equal 0, Game.non_scoring_dice_count([2,2,2])
    assert_equal 0, Game.non_scoring_dice_count([3,3,3])
    assert_equal 0, Game.non_scoring_dice_count([4,4,4])
    assert_equal 0, Game.non_scoring_dice_count([5,5,5])
    assert_equal 0, Game.non_scoring_dice_count([6,6,6])
  end
  
  def test_non_scoring_dice_of_mixed
    assert_equal 3, Game.non_scoring_dice_count([2,3,4,5,1])
    assert_equal 3, Game.non_scoring_dice_count([1,2,1,6,6])
    assert_equal 1, Game.non_scoring_dice_count([1,2])
  end
end