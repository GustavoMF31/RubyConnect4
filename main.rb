require_relative "board"
require_relative "human_player"
require_relative "random_ai"
require_relative "mimic_ai"
require_relative "mimic_offset"
require_relative "minimax.rb"

player_classes = [Human, RandomAI, MimicAI, MimicOffset, MiniMax]


player_classes.each_with_index do |player_class, i|
    puts "#{i+1} - #{player_class}"
end
print "\n"


print "P1: "
p1_index = gets.to_i - 1

print "P2: "
p2_index = gets.to_i - 1


game_board = Board.new

players = [player_classes[p1_index].new(), player_classes[p2_index].new()]

player_index = 0
while not (game_board.winner || game_board.full?)
    player = players[player_index]
    game_board.make_move!(player_index + 1, player.get_move(game_board, player_index +1))
    player_index = (player_index == 0) ? 1 : 0
end

puts game_board.to_s

if game_board.winner
    print "The winner is #{game_board.winner}!"
else
    print "I's a draw!"
end