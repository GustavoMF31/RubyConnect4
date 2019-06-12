class MiniMax
    INFINITY = Float::INFINITY

    # How many "points" each line is worth
    LINE4VALUE = INFINITY
    LINE3VALUE = 10
    LINE2VALUE = 1

    def get_move(board, player_num)
        depth = choose_depth(board)

        if player_num == 1
            pos_value, move = minimax(board, player_num, true, depth)
        else
            pos_value, move = minimax(board, player_num, false, depth)
        end

        return move

    end

    def minimax(board, player_num, maximize, depth)

        if depth == 0
            return [eval(board), nil]
        end

        if board.full?
            return [0, nil]
        end

        if maximize
            best_move = [-INFINITY, board.valid_cols_indexes[0]]
        else
            best_move = [INFINITY, board.valid_cols_indexes[0]]
        end

        opponent = (player_num == 1)? 2:1


        # Iterate over the valid moves
        board.valid_cols_indexes.each do |col_index|
            # Get the board with the move applied to it
            test_board = board.test_move(player_num, col_index)

            # If the move wins the game, choose it
            if test_board.winner == player_num
                if maximize
                    return [INFINITY, col_index]
                else
                    return [-INFINITY, col_index]
                end
            end

            # See what's the opponents best response to this move
            pos_value, response_move = minimax(test_board, opponent, !maximize, depth - 1)

            # If the move is better than the current best move, save it
            if maximize
                if pos_value > best_move[0]
                    best_move = [pos_value, col_index]
                end
            else
                if pos_value < best_move[0]
                    best_move = [pos_value, col_index]
                end
            end

        end

        if best_move[1] == nil
            puts "DEBUG"
            puts "board=#{board.to_s}"
            puts "best_move=#{best_move}"
            puts "maximize=#{maximize}"
            puts "depth=#{depth}"
            puts "player_num=#{player_num}"

        end

        return best_move

    end

    def choose_depth(board)
        # Choose the most appropriate depth
        # According to how many open columns are left

        open_cols = board.valid_cols_indexes.length

        return 4 if open_cols == 7 || open_cols == 6
        return 5 if open_cols == 5 || open_cols == 4
        return 7 if open_cols == 3
        return 11 if open_cols == 2 || open_cols == 1


    end

    def eval(board)
        # Tells how good the position is for Player1

        p1lines = board.count_line(1)
        p2lines = board.count_line(2)

        lines_diff = p1lines.zip(p2lines).map { |a, b| a - b }


        return  lines_diff[0] * LINE2VALUE +
                lines_diff[1] * LINE3VALUE
    end
end