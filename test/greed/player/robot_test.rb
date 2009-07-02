require File.dirname(__FILE__) + '/../../test_helper'

class TestRobot < Test::Unit::TestCase
  def setup
    @robot = Greed::Player::Robot.new
  end
  
  def test_name_is_robot
    assert_equal "Robot", @robot.name
  end
  
  def test_never_keeps_rolling
    assert !@robot.keep_rolling?(stats, turn_scores)
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
end