require "colorize"

class Board
    attr_accessor:cols, :positions_history, :moves_history
    def initialize(cols=[[0, 0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0, 0]])

        # 0 -> Empty
        # 1 -> P1
        # 2 -> P2

        @positions_history = []
        @moves_history = []

        # Initialize empty board
        @cols = cols
    end


    def make_move!(player, col_index)
        # Player can be 1 or 2

        if not (player == 1 || player == 2)
            raise "Bad player value"
        end

        # Column where the move will happen
        move_col = @cols[col_index]

        first_empty = move_col.find_index {|p| p == 0}

        if not first_empty
            raise "Bad move"
        end

        @moves_history << col_index

        move_col[first_empty] = player

        # Saves a copy of the board position to the history
        @positions_history << @cols.map { |e| e.clone }
    end

    def test_move(player, col_index)
        # Returns a new Board with the move applied

        board_copy = @cols.map { |e| e.clone }

        move_col = board_copy[col_index]
        first_empty = move_col.find_index {|p| p == 0}

        board_copy[col_index][first_empty] = player

        return Board.new(board_copy)
    end

    def full?

        @cols.each do |col|
            col.each do |piece|
                if piece == 0
                    return false
                end
            end
        end

        return true
    end


    def valid_cols_indexes
        indexes = []

        @cols.each_with_index do |col, i|
            if (col[-1] == 0)
                indexes << i
            end
        end

        indexes
    end

    def winner

        v_line = vertical_line
        return v_line if v_line

        h_line = horizontal_line
        return h_line if h_line

        d_line = diagonal_line
        return d_line if d_line

        return nil
    end
    def count_line(player)

        vertical = count_vertical_line(player)
        horizontal = count_horizontal_line(player)
        diagonal = count_diagonal(player)

        return vertical.zip(horizontal, diagonal).map { |a, b, c| a+b+c }
    end

    def vertical_line

        @cols.each do |col|
            col[0, 3].each_with_index do |piece, i|
                if piece != 0 &&
                   piece == col[i+1] &&
                   piece == col[i+2] &&
                   piece == col[i+3]

                    return piece

                end
            end
        end

        nil
    end
    def count_vertical_line(player)

        lines = [0, 0, 0]

        @cols.each do |col|
            col[0, 3].each_with_index do |piece, i|

                piece2 = col[i+1]
                piece3 = col[i+2]
                piece4 = col[i+3]

                lines = check_line(lines, player, piece, piece2, piece3, piece4)

            end
        end

        return lines
    end


    def horizontal_line
        rows = @cols.transpose

        rows.each do |rows|
            rows[0, 4].each_with_index do |piece, i|
                if piece != 0 &&
                   piece == rows[i+1] &&
                   piece == rows[i+2] &&
                   piece == rows[i+3]

                    return piece

                end
            end
        end

        nil

    end
    def count_horizontal_line(player)

        lines = [0, 0, 0]

        rows = @cols.transpose

        rows.each do |rows|
            rows[0, 4].each_with_index do |piece, i|

                piece2 = rows[i+1]
                piece3 = rows[i+2]
                piece4 = rows[i+3]

                lines = check_line(lines, player, piece, piece2, piece3, piece4)

            end
        end

        return lines
    end


    def diagonal_line

        f_diagonal = forward_diagonal
        return f_diagonal if f_diagonal
        
        b_diagonal = backwards_diagonal
        return b_diagonal if b_diagonal

        return nil

    end
    def count_diagonal(player)
        forward = count_forward_diagonal(player)
        backwards = count_backwards_diagonal(player)

        return forward.zip(backwards).map { |a, b| a + b }
    end

    def forward_diagonal

        @cols[0, 4].each_with_index do |col, i|
            col[0, 3].each_with_index do |piece, j|
                if piece != 0 &&
                   piece == @cols[i+1][j+1] &&
                   piece == @cols[i+2][j+2] &&
                   piece == @cols[i+3][j+3]

                    return piece

                end
            end
        end

        return nil
    end
    def count_forward_diagonal(player)

        lines = [0, 0, 0]

        @cols[0, 4].each_with_index do |col, i|
            col[0, 3].each_with_index do |piece, j|

                piece2 = @cols[i+1][j+1]
                piece3 = @cols[i+2][j+2]
                piece4 = @cols[i+3][j+3]

                lines = check_line(lines, player, piece, piece2, piece3, piece4)

            end
        end

        return lines
    end


    def backwards_diagonal

        @cols.each_with_index do |col, i|
            col.each_with_index do |piece, j|
                if i >= 3 and j < 3 and piece != 0
                    
                    if piece == @cols[i-1][j+1] &&
                       piece == @cols[i-2][j+2] &&
                       piece == @cols[i-3][j+3]

                        return piece
                    end

                end
            end
        end

        return nil
    end
    def count_backwards_diagonal(player)

        lines = [0, 0, 0]

        @cols.each_with_index do |col, i|
            col.each_with_index do |piece, j|
                if i >= 3 && j < 3

                    piece2 = @cols[i-1][j+1]
                    piece3 = @cols[i-2][j+2]
                    piece4 = @cols[i-3][j+3]

                    lines = check_line(lines, player, piece, piece2, piece3, piece4)

                end
            end
        end

        return lines

    end

    def check_line(current_lines, player, piece, piece2, piece3, piece4)

        pieces = [piece, piece2, piece3, piece4]
        empty = 0
        player_pieces = 0
        opponent_pieces = 0

        # Count the pieces
        pieces.each do |p|
            if p == 0
                empty += 1
            elsif p == player
                player_pieces += 1
            else
                opponent_pieces += 1
            end
        end

        # Line of 4
        if player_pieces == 4
            current_lines[2] += 1

        # "Line" of 3 
        # Not really a line because the pieces might be spaced
        # More like a "threat" made of 3 pieces
        elsif player_pieces == 3 &&
              empty == 1

            current_lines[1] += 1

        # "Threat" of 2
        elsif player_pieces == 2 &&
              empty == 2

            current_lines[0] += 1
        end

        return current_lines

    end

    def color(char)
        return char.blue if char == "1"
        return char.red  if char == "2"

        return char
    end

    def color_array(a)
        return a.map { |e| color(e.to_s) }
    end

    def to_s
        @cols.transpose.reverse.map { |a| color_array(a).join(" ") } .join("\n")
    end

end