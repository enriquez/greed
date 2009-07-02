# Greed Dice Game

This game is played in the console by running bin/greed in the root of this project.  The [rules can be found here](http://github.com/edgecase/ruby_koans/blob/9e799a71784e1112a048eb61b5a3acdf33418398/koans/GREED_RULES.txt)

## How to start the game

1. Run bin/greed
2. Select at least 2 players
3. If you selected any human players you'll be asked if you want to keep rolling.  Just say "y" or "n"

## Plans

* Game should keep going if there is a tie for first
* Make the robot smarter
* Automatically find players in player directory to make them selectable.
* Build a rake task to create a skeleton for a player.  Allow people to implement their own keep_rolling? algorithm and have them duke it out against each other by simulating the game.

## Credits

The UI class was taken and modified from [Ryan Bates' ruby-warrior](http://github.com/ryanb/ruby-warrior)

The idea and the DiceSet class credit goes to [Edge Case's ruby_koans](http://github.com/edgecase/ruby_koans)