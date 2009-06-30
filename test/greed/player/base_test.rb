require File.dirname(__FILE__) + '/../../test_helper'

class TestBase < Test::Unit::TestCase
  
  def setup
    @player = Player::Base.new
  end
  
  def test_should_have_a_default_name
    assert_equal "Ace of Base", @player.name
  end
  
  def test_should_have_a_default_position
    assert_equal 0, @player.position
  end
  
  def test_should_set_a_new_position
    @player.position = 3
    assert_equal 3, @player.position
  end
  
  def test_should_roll_the_dice_set
    DiceSet.expects(:roll).with(5).returns([1,1,1,1,1])
    assert_equal [1,1,1,1,1], @player.roll(DiceSet, 5)
  end
end