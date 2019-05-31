require "pry"

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

        #Initialize empty board
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
        #Returns a new Board with the move applied

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
        if full?
            nil
        else
            line
        end

    end


    def line

        if vertical_line
            vertical_line
        elsif horizontal_line
            horizontal_line
        elsif diagonal_line
            diagonal_line
        end

    end


    def vertical_line

        @cols.each do |col|
            col[0, 4].each_with_index do |piece, i|
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


    def diagonal_line

        if forward_diagonal
            forward_diagonal
        elsif backwards_diagonal
            backwards_diagonal
        end
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

    def count_lines(player)

        if not (player == 1 || player == 2)
            raise "Bad player value for count_lines"
        end


        # pieces_count = [2pieces_line, 3pieces_line, 4pieces_line ... ]
        pieces_count = [0,0,0,0,0,0]

        @cols.each_with_index do |col, i|
            col.each_with_index do |piece, j|

                cols_behind = i
                cols_forward = 6 - i

                pieces_on_top = 5 - j

                last = true

                # Vertical line (up)
                (1..pieces_on_top).each do |k|
                    if @cols[i][j+k] == player && piece == @cols[i][j+k] && last
                        #binding.pry
                        pieces_count[k - 1] += 1
                    else
                        last = false
                    end
                end

                last = true

                # Horizontal line (right)
                (1..cols_forward).each do |k|
                    if @cols[i+k][j] == player && piece == @cols[i][j+k] && last
                        pieces_count[k - 1] += 1
                    else
                        last = false
                    end
                end

                last = true

                # Backwards diagonal (left, up)
                (1..cols_behind).each do |k|
                    if @cols[i-k][j+k] == player && piece == @cols[i][j+k] && last
                        binding.pry
                        pieces_count[k - 1] += 1
                    else
                        last = false
                    end
                end

                last = true

                # Forwards diagonal (right, up)
                (1..cols_forward).each do |k|
                    if @cols[i+k][j+k] == player && piece == @cols[i][j+k] && last
                        pieces_count[k - 1] += 1
                    else
                        last = false
                    end
                end

            end
        end

        return pieces_count
    end

    def to_s
        @cols.transpose.reverse.map { |e| e.join(" ") } .join("\n")
    end

end