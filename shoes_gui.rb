Shoes.setup do
    gem "colorize"
end

require "board"
require "minimax"

PIECE_SIZE = 38
TOP_MARGIN = 40
LEFT_MARGIN = 20


def string_to_board(str)
    Board.new(str.split.map { |e| e.to_i }.each_slice(7).to_a.transpose.map { |e| e.reverse })
end


def draw_piece(player, piece_x, piece_y)
    stroke black
    fill player == 1 ? blue : red

    shape = oval :left => piece_x * PIECE_SIZE * 2 + LEFT_MARGIN,
                 :top  => piece_y * PIECE_SIZE * 2 + TOP_MARGIN,
                 :radius => PIECE_SIZE

    @shapes << shape
end

def draw_board(board)
    board.cols.map {|a| a.reverse} .each_with_index do |col, i|
        col.each_with_index do |piece, j|
            if piece != 0
                draw_piece(piece, i, j)
            end
        end
    end
end


def redraw_board(board)
    remove_all_pieces
    draw_board(board)
end


def remove_all_pieces
    @shapes.map { |e| e.remove }
end


def check_for_winner

    @winner = @game_board.winner
    if @winner
        @game_ended = true
    end
end


Shoes.app do
    @game_board = Board.new
    @opponent = MiniMax.new
    @shapes = []

    @game_ended = false
    @winner = nil

    flow margin: 0 do
        (1..7).each do |i|
            button i.to_s, margin: [19, 0, 19, 0] do
                next if @game_ended

                @game_board.make_move!(1, i - 1)
                redraw_board(@game_board)
                check_for_winner

                next if @game_ended

                opponent_move = @opponent.get_move(@game_board, 2)
                @game_board.make_move!(2, opponent_move)
                redraw_board(@game_board)
                check_for_winner

                
            end
        end
    end
end