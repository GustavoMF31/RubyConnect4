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
    def count_line(player)
        # It currently doesnt count "lines" where the missing piece is 
        # in the middle (like 1011), and consequently fails at recognizing
        # some opportunities and threats. Fix that

        vertical = count_vertical_line(player)
        horizontal = count_horizontal_line(player)
        diagonal = count_diagonal(player)

        return vertical.zip(horizontal, diagonal).map { |a, b, c| a+b+c }
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
    def count_vertical_line(player)

        line2, line3, line4 = [0, 0, 0]

        @cols.each do |col|
            col[0, 4].each_with_index do |piece, i|
                if piece == player

                    equal1 = piece == col[i+1]
                    equal2 = piece == col[i+2]
                    equal3 = piece == col[i+3]

                    if equal1 && equal2 && equal3
                        line4 +=1
                    elsif equal1 && equal2 && col[i+3] == 0
                        line3 +=1
                    elsif equal1 && col[i+2] == 0 && col[i+3] == 0
                        line2 += 1
                    end

                end
            end
        end

        return [line2, line3, line4]
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

        line2, line3, line4 = [0, 0, 0]

        rows = @cols.transpose

        rows.each do |rows|
            rows[0, 4].each_with_index do |piece, i|
                if piece == player

                    equal1 = piece == rows[i+1]
                    equal2 = piece == rows[i+2]
                    equal3 = piece == rows[i+3]

                    if equal1 && equal2 && equal3
                        line4 +=1
                    elsif equal1 && equal2 && rows[i+3] == 0
                        line3 +=1
                    elsif equal1 && rows[i+2] == 0 && rows[i+3] == 0
                        line2 += 1
                    end

                end
            end
        end

        return [line2, line3, line4]
    end


    def diagonal_line

        if forward_diagonal
            forward_diagonal
        elsif backwards_diagonal
            backwards_diagonal
        end
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

        line2, line3, line4 = [0, 0, 0]

        @cols[0, 4].each_with_index do |col, i|
            col[0, 3].each_with_index do |piece, j|
                if piece == player

                    equal1 = piece == @cols[i+1][j+1]
                    equal2 = piece == @cols[i+2][j+2]
                    equal3 = piece == @cols[i+3][j+3]

                    if equal1 && equal2 && equal3
                        line4 +=1
                    elsif equal1 && equal2 && @cols[i+3][j+3] == 0
                        line3 +=1
                    elsif equal1 && @cols[i+2][j+2] == 0 && @cols[i+3][j+3] == 0
                        line2 += 1
                    end

                end
            end
        end

        return [line2, line3, line4]
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

        line2, line3, line4 = [0, 0, 0]

        @cols.each_with_index do |col, i|
            col.each_with_index do |piece, j|
                if i >= 3 && j < 3 && piece == player

                    equal1 = piece == @cols[i-1][j+1]
                    equal2 = piece == @cols[i-2][j+2]
                    equal3 = piece == @cols[i-3][j+3]

                    if equal1 && equal2 && equal3
                        line4 +=1
                    elsif equal1 && equal2 && @cols[i-3][j+3] == 0
                        line3 +=1
                    elsif equal1 && @cols[i-2][j+2] == 0 && @cols[i-3][j+3] == 0 
                        line2 += 1
                    end

                end
            end
        end

        return [line2, line3, line4]

    end

    def to_s
        @cols.transpose.reverse.map { |e| e.join(" ") } .join("\n")
    end

end