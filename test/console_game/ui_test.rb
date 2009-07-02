require File.dirname(__FILE__) + '/../test_helper'

class TestUI < Test::Unit::TestCase
  
  def setup
    @ui = UI
    @out = StringIO.new
    @in = StringIO.new
    @ui.out_stream = @out
    @ui.in_stream = @in
  end
  
  def test_puts_to_out_stream
    @ui.puts "Hello World"
    assert_equal "Hello World\n", @out.string
  end
  
  def test_prints_to_out_stream
    @ui.print "Hello World"
    assert_equal "Hello World", @out.string
  end
  
  def test_gets_from_in_stream
    user_inputs "user input"
    assert_equal "user input\n", @ui.gets
  end
  
  def test_gets_empty_string_with_no_input
    @ui.in_stream = nil
    assert_equal "", @ui.gets
  end
  
  def test_request_for_user_input
    user_inputs "bar"
    assert_equal "bar", @ui.request("Foo?")
    assert_equal "Foo?", @out.string
  end
  
  def test_ask_for_yes_no_returns_true_if_yes
    user_inputs "y"
    assert @ui.ask("Do you say yes?")
    assert_equal "Do you say yes? [yn] ", @out.string
  end
  
  def test_ask_for_yes_no_returns_false_if_no
    user_inputs "n"
    assert !@ui.ask("Do you say yes?")
    assert_equal "Do you say yes? [yn] ", @out.string
  end
  
  def test_ask_for_yes_no_returns_false_if_giberrish
    user_inputs "gibberish"
    assert !@ui.ask("Do you say yes?")
    assert_equal "Do you say yes? [yn] ", @out.string
  end
  
  def test_should_present_multiple_options_and_return_selected_one
    user_inputs "2"
    assert_equal :bar, @ui.choose("Select a thingy: ", [:foo, :bar, :dude])
    assert_match /\[1\] foo/, @out.string
    assert_match /\[2\] bar/, @out.string
    assert_match /\[3\] dude/, @out.string
  end
  
  def user_inputs input
    @in.puts input
    @in.rewind
  end
end