# Greed Dice Game

This game is played in the console by running bin/greed in the root of this project.  The [rules can be found here](http://github.com/edgecase/ruby_koans/blob/9e799a71784e1112a048eb61b5a3acdf33418398/koans/GREED_RULES.txt)

## How to start the game

1. Run bin/greed
2. Select at least 2 players
3. If you selected any human players you'll be asked if you want to keep rolling.  Just say "y" or "n"

## Project Status

Still in early development.  It is kind've playable, but the robot is dumb and never keeps rolling.  Also, the user interface is clunky.  The logic in the executable needs to be moved to a class and tested.

## Plans

* The user interface needs to be cleaned up a ton.
* UI should be taken out of the game class.  Game class should just notify spectators and players of certain events.
* Build a rake task to create a skeleton for a player.  Allow people to implement their own keep_rolling? algorithm and have them duke it out against each other by simulating the game.


## Credits

The UI class and much of the structure was taken from [Ryan Bate's ruby-warrior](http://github.com/ryanb/ruby-warrior)

The idea and the DiceSet class credit goes to [Edge Case's ruby_koans](http://github.com/edgecase/ruby_koans)