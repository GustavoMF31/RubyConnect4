require_relative "board"

def string_to_board(str)
    Board.new(str.split.map { |e| e.to_i }.each_slice(7).to_a.transpose.map { |e| e.reverse })
end

puts string_to_board("0 0 0 0 0 0 0
2 0 0 0 0 0 0
1 1 2 2 0 0 0
2 2 1 1 0 0 0
2 2 1 1 0 0 0
2 1 2 1 1 0 0").count_lines(1)