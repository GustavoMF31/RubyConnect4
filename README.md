# RubyConnect4

The game of Connect 4 made in the Ruby programming language

[Connect 4 on Wikipedia](https://en.wikipedia.org/wiki/Connect_Four)

The project consists of three main parts: the **Board** class, that implements the game logic, the **MiniMax AI**, that you can play against, and the **User Interface**, made with the [Shoes GUI toolkit](http://shoesrb.com/)

## Board

This class is responsible for keeping track and altering the the game's state, by:

- Making moves
- Making sure there are still available columns
- Checking horizontal, vertical and diagonal lines for a winner
- Formatting the board into a string

## MiniMax AI

This is an implementation of the [MiniMax Algorithm](https://en.wikipedia.org/wiki/Minimax), a type of recursive algorithm vastly used for playing board games.
As a ***heuristic function*** (a function used to assign a score to a board position that lets the algorithm choose beetween different positions) it uses the difference beetween how many threats it has and how many threats the opponent has.

A threat is a line of less than 4 pieces that can be turned into a line of 4 pieces.
It values lines of 3 pieces more, because they are closer to becoming a line of 4 pieces than a line of 2 pieces.

## User Interface

The user interface code is responsible for drawing the pieces on the screen and responding to the button presses, manipulating the game accordingly. To use it:
- Clone the repository
- Download [Shoes](http://shoesrb.com/downloads/)
- Use it to open the ```shoes_gui.rb``` file

It currently only supports playing against the MiniMax. To play against other simpler AI strategies, run the ```main.rb``` script from the comand line. The project uses the ```colorize``` gem to color the output, so install it first.
