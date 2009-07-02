require File.dirname(__FILE__) + '/../../test_helper'

class TestHuman < Test::Unit::TestCase
  
  def setup
    @human = Player::Human.new
    @human.position = 0
  end
  
  def test_name_is_player_position
    assert_equal "Human", @human.name
  end
  
  def test_keep_rolling_returns_true_if_user_says_y
    UI.expects(:ask).with("Player 1: Keep Rolling?").returns(true)
    
    assert @human.keep_rolling?(stats, turn_scores, dice_remaining)
  end
  
  def test_keep_rolling_returns_false_if_user_says_n
    UI.expects(:ask).with("Player 1: Keep Rolling?").returns(false)
    
    assert !@human.keep_rolling?(stats, turn_scores, dice_remaining)
  end
  
  def stats
    {
      :round => 3,
      :scores => [100, 0]
    }
  end
  
  def turn_scores
    [100]
  end
  
  def dice_remaining
    5
  end
end