require File.dirname(__FILE__) + '/../../test_helper'

class TestRobot < Test::Unit::TestCase
  def setup
    @robot = Greed::Player::Robot.new
  end
  
  def test_name_is_robot
    assert_equal "Robot", @robot.name
  end
  
  def test_rolls_if_there_are_at_least_3_die_available
    assert @robot.keep_rolling?(stats, turn_scores, 5)
    assert @robot.keep_rolling?(stats, turn_scores, 4)
    assert @robot.keep_rolling?(stats, turn_scores, 3)
    assert !@robot.keep_rolling?(stats, turn_scores, 2)
    assert !@robot.keep_rolling?(stats, turn_scores, 1)
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